#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["mcp>=1.25", "anyio", "httpx", "httpx-sse"]
# ///
"""Jina AI MCP tool caller.

Usage:
    jina search_web query:"search terms" num:10
    jina read_url url:"https://example.com"
    jina classify_text --args '{"texts":["a","b"],"labels":["x","y"]}'
    jina --list
    jina --setup              # first-time auth setup
"""
import argparse
import json
import sys
from functools import partial
from pathlib import Path

import anyio

from mcp.client.session import ClientSession
from mcp.client.streamable_http import streamablehttp_client

SERVER_NAME = "jina"
SERVER_URL = "https://mcp.jina.ai/v1"
NEEDS_AUTH = True
CFG_PATH = Path.home() / ".config" / "mcpcall" / "servers.json"


def load_headers() -> dict[str, str]:
    if CFG_PATH.exists():
        servers = json.loads(CFG_PATH.read_text())
        if SERVER_NAME in servers:
            return servers[SERVER_NAME].get("headers", {})
    claude_json = Path.home() / ".claude.json"
    if claude_json.exists():
        cfg = json.loads(claude_json.read_text())
        entry = cfg.get("mcpServers", {}).get(SERVER_NAME, {})
        return entry.get("headers", {})
    return {}


def setup():
    print(f"Setup: {SERVER_NAME} MCP server")
    key = input("Enter Jina API key (from https://jina.ai/api-key): ").strip()
    if not key:
        print("error: empty key", file=sys.stderr)
        sys.exit(1)
    CFG_PATH.parent.mkdir(parents=True, exist_ok=True)
    servers: dict = {}
    if CFG_PATH.exists():
        servers = json.loads(CFG_PATH.read_text())
    servers[SERVER_NAME] = {
        "url": SERVER_URL,
        "headers": {"Authorization": f"Bearer {key}"},
    }
    CFG_PATH.write_text(json.dumps(servers, indent=2) + "\n")
    print(f"saved to {CFG_PATH}")


def parse_kv_args(args: list[str]) -> dict:
    result = {}
    for arg in args:
        if ":" not in arg:
            print(f"error: bad arg '{arg}', expected key:value", file=sys.stderr)
            sys.exit(1)
        key, val = arg.split(":", 1)
        if val.lower() == "true":
            result[key] = True
        elif val.lower() == "false":
            result[key] = False
        else:
            try:
                result[key] = int(val)
            except ValueError:
                try:
                    result[key] = float(val)
                except ValueError:
                    result[key] = val
    return result


async def call_tool(headers: dict, tool_name: str, arguments: dict) -> bool:
    async with streamablehttp_client(SERVER_URL, headers=headers, timeout=15) as (rs, ws, _):
        async with ClientSession(rs, ws) as session:
            await session.initialize()
            result = await session.call_tool(tool_name, arguments)
            for item in result.content:
                if hasattr(item, "text"):
                    print(item.text)
                elif hasattr(item, "data"):
                    print(f"[binary: {item.mimeType}, {len(item.data)} bytes]")
                else:
                    print(item)
            return result.isError or False


async def list_tools(headers: dict):
    async with streamablehttp_client(SERVER_URL, headers=headers, timeout=15) as (rs, ws, _):
        async with ClientSession(rs, ws) as session:
            await session.initialize()
            result = await session.list_tools()
            for tool in result.tools:
                desc = (tool.description or "")[:60]
                print(f"  {tool.name:30s} {desc}")


def main():
    parser = argparse.ArgumentParser(description=f"Call {SERVER_NAME} MCP tools")
    parser.add_argument("tool", nargs="?", help="Tool name (e.g. search_web)")
    parser.add_argument("kv_args", nargs="*", help="key:value arguments")
    parser.add_argument("--args", dest="json_args", help="JSON arguments string")
    parser.add_argument("--list", action="store_true", help="List available tools")
    parser.add_argument("--setup", action="store_true", help="Configure API key")
    args = parser.parse_args()

    if args.setup:
        setup()
        return

    headers = load_headers()
    if NEEDS_AUTH and not headers:
        print(f"error: {SERVER_NAME} requires authentication.", file=sys.stderr)
        print(f"Run with --setup to configure, or add to {CFG_PATH}", file=sys.stderr)
        sys.exit(1)

    if args.list:
        anyio.run(partial(list_tools, headers), backend="asyncio")
    elif args.tool:
        arguments = {}
        if args.kv_args:
            arguments.update(parse_kv_args(args.kv_args))
        if args.json_args:
            arguments.update(json.loads(args.json_args))
        is_error = anyio.run(partial(call_tool, headers, args.tool, arguments), backend="asyncio")
        if is_error:
            sys.exit(1)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
