FROM python:3.12-slim-bookworm

# System deps + Node.js in one layer (single apt-get update/clean cycle)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo curl git wget ca-certificates gnupg zsh && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Dev tools: uv, Claude CLI, starship
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    npm install -g @anthropic-ai/claude-code && \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

ENV PATH="/root/.local/bin:$PATH"

# Zsh plugins
RUN mkdir -p /root/.zsh/plugins && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting /root/.zsh/plugins/zsh-syntax-highlighting

# Zsh config
RUN printf '%s\n' \
    'autoload -Uz compinit && compinit' \
    'HISTFILE=~/.zsh_history' \
    'HISTSIZE=10000' \
    'SAVEHIST=10000' \
    'setopt HIST_IGNORE_DUPS SHARE_HISTORY' \
    'source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' \
    'source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
    'eval "$(starship init zsh)"' \
    > /root/.zshrc
