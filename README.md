# devcontainer-templates

Personal dev container templates. Published to GHCR and usable from VS Code's "Add Dev Container Configuration Files" picker.

## Templates

### `python-base`
Python 3.12 + uv + zsh + starship + Claude CLI.
Barebones starting point for Python projects — no database, no frontend.

### `python-spark`
Ubuntu 22.04 + Python 3.11 + Spark 3.5 + Delta Lake + uv + zsh + starship + Claude CLI.
For data engineering / PySpark projects. Includes a Spark Connect server on port 15002 and Spark UI on port 4040.

## Usage in VS Code

1. `Ctrl+Shift+P` → **Dev Containers: Add Dev Container Configuration Files**
2. Select **Show All Definitions...**
3. Filter by your registry: `ghcr.io/YOUR_USERNAME`
4. Pick a template — it copies `.devcontainer/` into your project

## Publishing

Push a version tag to trigger the publish workflow:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Templates are published to `ghcr.io/YOUR_USERNAME/devcontainer-templates/python-base` and `ghcr.io/YOUR_USERNAME/devcontainer-templates/python-spark`.
