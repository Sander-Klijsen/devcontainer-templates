# python-base

Barebones Python dev container for general Python projects.

## What's installed

| Tool | Version | Notes |
|------|---------|-------|
| Python | 3.12 | via `python:3.12-slim-bookworm` |
| uv | latest | fast Python package manager |
| zsh | latest | default shell |
| starship | latest | shell prompt |
| zsh-autosuggestions | latest | grey suggestions as you type |
| zsh-syntax-highlighting | latest | command syntax highlighting |
| Claude CLI | latest | `claude` command available |

## User

Runs as **root** inside the container.

## VS Code extensions

- `ms-python.python` + `ms-python.vscode-pylance` — Python language support
- `charliermarsh.ruff` — linting and formatting
- `ms-python.mypy-type-checker` — type checking
- `tamasfe.even-better-toml` — TOML support (`pyproject.toml`)
- `mhutchie.git-graph` — git history viewer
- `anthropic.claude-code` — Claude Code

## Getting started

### 1. Copy the template into your new project

```bash
cp -r ~/projects/devcontainer-templates/src/python-base/.devcontainer ~/projects/my-new-project/
cd ~/projects/my-new-project
code .
```

### 2. Reopen in container

VS Code will detect `.devcontainer/` and prompt you to reopen in the container. Click **Reopen in Container**.

### 3. Initialise your project

```bash
# Create a new Python project
uv init

# Add dependencies
uv add requests pandas

# Run your code
uv run main.py
```

### 4. Start Claude

```bash
claude
```

## uv cheatsheet

```bash
uv init                  # initialise a new project (creates pyproject.toml)
uv add <package>         # add a dependency
uv add --dev <package>   # add a dev dependency
uv sync                  # install all dependencies from pyproject.toml
uv run <script>          # run a script inside the venv
uv run pytest            # run tests
```
