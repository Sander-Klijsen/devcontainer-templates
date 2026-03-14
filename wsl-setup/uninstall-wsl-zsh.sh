#!/bin/bash
set -e

echo "==> Removing zsh plugins..."
rm -rf ~/.zsh

echo "==> Removing starship..."
sudo rm -f /usr/local/bin/starship

echo "==> Removing starship config..."
rm -f ~/.config/starship.toml

echo "==> Removing zsh config..."
rm -f ~/.zshrc

echo "==> Setting bash as default shell..."
chsh -s $(which bash)

echo ""
echo "Done! Reopen your terminal to go back to bash."
