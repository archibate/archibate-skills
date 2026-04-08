#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["mcp>=1.25", "anyio", "httpx", "httpx-sse"]
# ///
"""Minimal MCP tool caller via Streamable HTTP.

Usage:
    mcpcall jina.primer
    mcpcall jina.search_web query:"search terms" num:10
    mcpcall jina.classify_text --args '{"texts":["a","b"],"labels":["x","y"]}'
    mcpcall --list jina
    mcpcall --add myserver --url https://mcp.example.com/v1
    mcpcall --add myserver --url https://mcp.example.com/v1 --header Authorization="Bearer key"

Reads server config from ~/.config/mcpcall/servers.json (primary),
falls back to ~/.claude.json mcpServers.
Respects http_proxy/https_proxy (via httpx).
"""
import argparse
import json
import sys
from functools import partial
from pathlib import Path

import anyio

from mcp.client.session import ClientSession
from mcp.client.streamable_http import streamablehttp_client


CFG_PATH = Path.home() / ".config" / "mcpcall" / "servers.json"


def add_server(name: str, url: str, headers: list[str]):
    CFG_PATH.parent.mkdir(parents=True, exist_ok=True)
    servers: dict = {}
    if CFG_PATH.exists():
        servers = json.loads(CFG_PATH.read_text())
    entry: dict = {"url": url}
    if headers:
        hdr = {}
        for h in headers:
            if "=" not in h:
                print(f"error: bad header '{h}', expected Key=Value", file=sys.stderr)
                sys.exit(1)
            k, v = h.split("=", 1)
            hdr[k] = v
        entry["headers"] = hdr
    servers[name] = entry
    CFG_PATH.write_text(json.dumps(servers, indent=2) + "\n")
    print(f"added '{name}' -> {url}")


def load_server_config(server_name: str) -> tuple[str, dict[str, str]]:
    servers: dict = {}
    # Primary: ~/.config/mcpcall/servers.json
    if CFG_PATH.exists():
        servers = json.loads(CFG_PATH.read_text())
    # Fallback: ~/.claude.json mcpServers
    if server_name not in servers:
        claude_json = Path.home() / ".claude.json"
        if claude_json.exists():
            cfg = json.loads(claude_json.read_text())
            servers.update(cfg.get("mcpServers", {}))
    if server_name not in servers:
        available = ", ".join(servers.keys()) or "(none)"
        print(f"error: server '{server_name}' not found. available: {available}", file=sys.stderr)
        print(f"\nTo add it, run:", file=sys.stderr)
        print(f"  mcpcall --add {server_name} --url https://mcp.example.com/v1", file=sys.stderr)
        print(f"\nOr edit {CFG_PATH} and add:", file=sys.stderr)
        print(f'  "{server_name}": {{"url": "https://mcp.example.com/v1"}}', file=sys.stderr)
        sys.exit(1)
    s = servers[server_name]
    return s["url"], s.get("headers", {})


def parse_kv_args(args: list[str]) -> dict:
    result = {}
    for arg in args:
        if ":" not in arg:
            print(f"error: bad arg '{arg}', expected key:value", file=sys.stderr)
            sys.exit(1)
        key, val = arg.split(":", 1)
        # auto-convert types
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


async def call_tool(url: str, headers: dict, tool_name: str, arguments: dict):
    async with streamablehttp_client(url, headers=headers, timeout=15) as (read_stream, write_stream, _):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()
            result = await session.call_tool(tool_name, arguments)
            for item in result.content:
                if hasattr(item, "text"):
                    print(item.text)
                elif hasattr(item, "data"):
                    print(f"[binary: {item.mimeType}, {len(item.data)} bytes]")
                else:
                    print(item)
            if result.isError:
                sys.exit(1)


async def list_tools(url: str, headers: dict):
    async with streamablehttp_client(url, headers=headers, timeout=15) as (read_stream, write_stream, _):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()
            result = await session.list_tools()
            for tool in result.tools:
                desc = (tool.description or "")[:60]
                print(f"  {tool.name:30s} {desc}")


def main():
    parser = argparse.ArgumentParser(description="Call MCP server tools")
    parser.add_argument("target", nargs="?", help="server.tool (e.g. jina.primer) or just server with --list")
    parser.add_argument("kv_args", nargs="*", help="key:value arguments")
    parser.add_argument("--args", dest="json_args", help="JSON arguments string")
    parser.add_argument("--list", action="store_true", help="List available tools")
    parser.add_argument("--add", metavar="NAME", help="Add a server to config")
    parser.add_argument("--url", help="Server URL (used with --add)")
    parser.add_argument("--header", action="append", default=[], help="Header Key=Value (used with --add, repeatable)")
    args = parser.parse_args()

    if args.add:
        if not args.url:
            print("error: --url is required with --add", file=sys.stderr)
            sys.exit(1)
        add_server(args.add, args.url, args.header)
        return

    if not args.target:
        parser.print_help()
        sys.exit(1)

    if args.list:
        server_name = args.target
        tool_name = None
    elif "." in args.target:
        server_name, tool_name = args.target.split(".", 1)
    else:
        print(f"error: expected server.tool, got '{args.target}'", file=sys.stderr)
        sys.exit(1)

    url, headers = load_server_config(server_name)

    if args.list:
        anyio.run(partial(list_tools, url, headers), backend="asyncio")
    else:
        arguments = {}
        if args.kv_args:
            arguments.update(parse_kv_args(args.kv_args))
        if args.json_args:
            arguments.update(json.loads(args.json_args))
        anyio.run(partial(call_tool, url, headers, tool_name, arguments), backend="asyncio")


if __name__ == "__main__":
    main()
