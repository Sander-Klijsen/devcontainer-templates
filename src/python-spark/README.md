# python-spark

Python + Apache Spark dev container for data engineering projects.

## What's installed

| Tool | Version | Notes |
|------|---------|-------|
| Ubuntu | 22.04 | base image |
| Python | 3.11 | required by Spark 3.5 runtime |
| Apache Spark | 3.5.0 | with Hadoop 3 |
| Delta Lake | 3.1.0 | `delta-spark` package |
| Java | 17 (OpenJDK) | required by Spark |
| uv | 0.9.30 | fast Python package manager |
| zsh | latest | default shell |
| starship | latest | shell prompt |
| zsh-autosuggestions | latest | grey suggestions as you type |
| zsh-syntax-highlighting | latest | command syntax highlighting |
| Claude CLI | latest | `claude` command available |

## User

Runs as **spark** (uid 1000) inside the container. Has passwordless sudo.

## Ports

| Port | Service |
|------|---------|
| 15002 | Spark Connect server |
| 4040 | Spark UI |

## Environment variables

| Variable | Value |
|----------|-------|
| `SPARK_HOME` | `/opt/spark` |
| `SPARK_REMOTE_URL` | `sc://localhost:15002` |
| `PYSPARK_PYTHON` | `python3` |
| `UV_LINK_MODE` | `copy` |
| `UV_CACHE_DIR` | `/tmp/uv-cache` |

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
cp -r ~/projects/devcontainer-templates/src/python-spark/.devcontainer ~/projects/my-new-project/
cd ~/projects/my-new-project
code .
```

### 2. Reopen in container

VS Code will detect `.devcontainer/` and prompt you to reopen in the container. Click **Reopen in Container**.

### 3. Initialise your project

```bash
# Create a new Python project
uv init

# Add dependencies (pyspark is already available via the system install)
uv add delta-spark

# Install all dependencies
uv sync
```

### 4. Start the Spark Connect server

The container image includes Spark but does not auto-start the server. Start it manually:

```bash
/opt/spark/sbin/start-connect-server.sh
```

Then check it's running by opening the Spark UI at http://localhost:4040.

### 5. Connect from Python

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.remote("sc://localhost:15002").getOrCreate()
df = spark.range(10)
df.show()
```

### 6. Start Claude

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

## Notes

- Python is pinned to **3.11** because Spark 3.5 targets the Azure Synapse 3.4 runtime which constrains Python to 3.10/3.11.
- Delta Lake jars are pre-configured in `/opt/spark/conf/spark-defaults.conf` — no extra config needed.
- `uv sync` runs automatically on container start if a `pyproject.toml` is present.
