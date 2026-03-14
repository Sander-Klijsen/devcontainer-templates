FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo curl git wget ca-certificates gnupg zsh \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install Node.js (for Claude CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude CLI
RUN npm install -g @anthropic-ai/claude-code

# Install starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Zsh plugins
RUN mkdir -p /root/.zsh/plugins \
    && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/plugins/zsh-autosuggestions \
    && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting /root/.zsh/plugins/zsh-syntax-highlighting

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
