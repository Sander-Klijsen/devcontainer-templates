#!/bin/bash
set -e

echo "==> Installing zsh..."
sudo apt-get update && sudo apt-get install -y zsh

echo "==> Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

echo "==> Installing zsh plugins..."
mkdir -p ~/.zsh/plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting

echo "==> Configuring ~/.zshrc..."
cat >> ~/.zshrc << 'EOF'
autoload -Uz compinit && compinit
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(starship init zsh)"
EOF

echo "==> Copying starship config..."
mkdir -p ~/.config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/../src/python-base/.devcontainer/starship.toml" ~/.config/starship.toml

echo "==> Setting zsh as default shell..."
chsh -s $(which zsh)

echo ""
echo "Done! Reopen your terminal to start using zsh."
