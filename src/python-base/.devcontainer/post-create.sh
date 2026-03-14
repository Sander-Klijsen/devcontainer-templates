#!/bin/bash
set -e

echo "==> Copying starship config..."
mkdir -p ~/.config
cp /workspace/.devcontainer/starship.toml ~/.config/starship.toml

echo "==> Configuring zsh..."
if ! grep -q 'starship init zsh' ~/.zshrc 2>/dev/null; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

echo ""
echo "Dev container ready. uv is available for dependency management."
echo "  uv init        # start a new project"
echo "  uv add <pkg>   # add a dependency"
