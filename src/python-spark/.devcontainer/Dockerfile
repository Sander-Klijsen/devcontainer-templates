# --- STAGE 1: Download Spark ---
FROM ubuntu:24.04 AS spark-downloader
ARG SPARK_VERSION=4.1.1
ARG HADOOP_VERSION=3
RUN apt-get update && apt-get install -y wget && \
    wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

# --- STAGE 2: Final Image ---
FROM ubuntu:24.04
ARG uv_version=0.10.10
ARG USER_ID=1000
ARG GROUP_ID=1000

USER root

# System dependencies: add deadsnakes PPA first so only one apt-get update needed
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    git openjdk-17-jre-headless wget curl procps sudo zsh \
    python3.14 python3.14-venv python3.14-dev && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install --yes --no-install-recommends nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=spark-downloader /opt/spark /opt/spark

# Python symlinks + uv + delta-spark + starship in one layer
RUN ln -sf /usr/bin/python3.14 /usr/bin/python && \
    ln -sf /usr/bin/python3.14 /usr/bin/python3 && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    /root/.local/bin/uv pip install --system delta-spark==4.1.0 && \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

# All environment variables in one statement
ENV PATH="/root/.local/bin:/opt/spark/bin:/opt/spark/sbin:$PATH" \
    SPARK_HOME=/opt/spark \
    PYSPARK_PYTHON=python3 \
    PYSPARK_DRIVER_PYTHON=python3

# User setup, spark config and permissions in one step to avoid layer ordering issues
RUN userdel -r ubuntu 2>/dev/null || true && \
    groupdel ubuntu 2>/dev/null || true && \
    groupadd -g ${GROUP_ID} spark && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/zsh spark && \
    echo "spark ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /opt/spark/conf && { \
    echo "spark.local.dir /tmp/spark-artifacts"; \
    echo "spark.connect.common.artifact.storage.dir /tmp/spark-artifacts"; \
    echo "spark.connect.server.artifact.directory /tmp/spark-artifacts/server"; \
    echo "spark.jars.packages io.delta:delta-spark_4.1_2.13:4.1.0,org.apache.spark:spark-connect_2.13:4.1.1"; \
    echo "spark.sql.extensions io.delta.sql.DeltaSparkSessionExtension"; \
    echo "spark.sql.catalog.spark_catalog org.apache.spark.sql.delta.catalog.DeltaCatalog"; \
    } > /opt/spark/conf/spark-defaults.conf && \
    mkdir -p /workspaces /tmp/spark-artifacts/server /home/spark/.ivy2/cache && \
    chown -R spark:spark /opt/spark /workspaces /tmp/spark-artifacts /home/spark && \
    chmod -R 755 /tmp/spark-artifacts

USER spark

# Zsh plugins + config
RUN mkdir -p ~/.zsh/plugins ~/.config && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting && \
    printf '%s\n' \
        'autoload -Uz compinit && compinit' \
        'HISTFILE=~/.zsh_history' \
        'HISTSIZE=10000' \
        'SAVEHIST=10000' \
        'setopt HIST_IGNORE_DUPS SHARE_HISTORY' \
        'source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' \
        'source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
        'eval "$(starship init zsh)"' \
        > ~/.zshrc

COPY --chown=spark:spark starship.toml /home/spark/.config/starship.toml

WORKDIR /workspaces
