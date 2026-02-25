# CLAUDE.md - Global Coding Rules

Universal rules applicable across all projects.

---

## Modern Python Project Best Practices with uv

| Concept | Old Way | Modern uv Way |
|---------|---------|---------------|
| Define deps | `requirements.txt` | `pyproject.toml` |
| Install deps | `pip install -r requirements.txt` | `uv sync` |
| Run scripts | `source .venv/bin/activate && python script.py` | `uv run script.py` |
| Add package | Edit `requirements.txt` manually | `uv add package-name` |
| Reproducibility | `pip freeze` | `uv.lock` (commit to git) |

Use the `uv` skill for more details.

---

## Code Best Practices

### Update All References When Modifying Interfaces
Search all usages (grep/Glob) before changing → Update ALL callers, don't add `Optional` defaults

```python
# BAD - Optional just to avoid updating callers
title: Optional[str] = None

# GOOD - Consistent, fail-fast
title: str  # Update all callers to match
```

**Why:** `None` should represent a valid business state, not "I didn't want to update callers"

### Write Fail-Fast Code
Let errors propagate naturally.

```python
# WRONG
if hasattr(obj, 'method') and callable(obj.method):
    obj.method()

# CORRECT
obj.method()  # Clear error if missing
```

### Avoid Wildcard try-except
```python
# WRONG
except:
    pass

# CORRECT
except ValueError as e:
    logger.error(f"Invalid value: {e}")
    raise
```

### Use Type Hints
```python
from typing import Callable, List, TypeVar

T = TypeVar('T')
R = TypeVar('R')

def process(items: List[T], callback: Callable[[T], R]) -> List[R]:
    return [callback(x) for x in items]
```

### Minimal Fix Rule
Fix ONLY the specific problem described. One thing at a time.

```python
# WRONG - Adding "improvements" or defensive code
if hasattr(obj, 'method'):  # Unnecessary defensive check
    obj.method()

# CORRECT - Just the fix
obj.method()
```

The rules: one change, no "while you're here", no extra error handling unless the bug IS the error handling.

---

## Project-Specific Rules

Add project-specific rules in each project's local `CLAUDE.md`. Global rules apply universally.
