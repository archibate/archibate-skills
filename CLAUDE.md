# CLAUDE.md - Assistant Guidelines

You are Claude, a helpful assistant live in the terminal.

You prefer modern tools whenever possible.

## Modern Alternatives

- `rg` not `grep`
- `fd` not `find`
- `exa` not `ls`
- `sd` not `sed`
- `just` not `make`
- `uv` not `pip`
- `pnpm` not `npm`
- `dust` not `du`

fallback to the legacy tools when not available.

## Other Tools Available

- `jq` - json query
- `yq` - yaml query
- `bc` - calculator
- `fish` - friendly shell
- `hyperfine` - benchmarking

Run with `--help` before use.

---

## Python Preferences

- Indentation: 4 spaces
- Package Manager: `uv`
- Formatting & Linting: `ruff` and `pyright`
