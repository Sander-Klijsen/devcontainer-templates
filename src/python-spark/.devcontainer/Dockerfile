# --- STAGE 1: Download Spark ---
FROM ubuntu:22.04 AS spark-downloader
ARG SPARK_VERSION=3.5.0
ARG HADOOP_VERSION=3
RUN apt-get update && apt-get install -y wget && \
    wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

# --- STAGE 2: Final Image ---
FROM ubuntu:22.04
ARG uv_version=0.9.30
ARG USER_ID=1000
ARG GROUP_ID=1000

USER root

# System dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    git software-properties-common python3.11 python3.11-venv \
    python3.11-dev python3-pip openjdk-17-jre-headless wget curl procps sudo zsh && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install --yes --no-install-recommends nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=spark-downloader /opt/spark /opt/spark

# Python + uv + delta-spark
RUN ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    pip install --no-cache-dir delta-spark==3.1.0 uv==${uv_version}

# Environment variables
ENV SPARK_HOME=/opt/spark \
    PATH=$PATH:/opt/spark/bin:/opt/spark/sbin \
    PYSPARK_PYTHON=python3 \
    PYSPARK_DRIVER_PYTHON=python3 \
    UV_INSTALL_DIR="/usr/lib/uv"

# User setup
RUN groupadd -g ${GROUP_ID} spark || true && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/zsh spark || true && \
    echo "spark ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Spark config (Delta + Connect)
RUN mkdir -p /opt/spark/conf && { \
    echo "spark.local.dir /tmp/spark-artifacts"; \
    echo "spark.connect.common.artifact.storage.dir /tmp/spark-artifacts"; \
    echo "spark.connect.server.artifact.directory /tmp/spark-artifacts/server"; \
    echo "spark.jars.packages io.delta:delta-spark_2.12:3.1.0,org.apache.spark:spark-connect_2.12:3.5.0"; \
    echo "spark.sql.extensions io.delta.sql.DeltaSparkSessionExtension"; \
    echo "spark.sql.catalog.spark_catalog org.apache.spark.sql.delta.catalog.DeltaCatalog"; \
    } > /opt/spark/conf/spark-defaults.conf

# Permissions
RUN mkdir -p /workspaces /tmp/spark-artifacts/server /home/spark/.ivy2/cache && \
    chown -R spark:spark /opt/spark /workspaces /tmp/spark-artifacts /home/spark && \
    chmod -R 777 /tmp/spark-artifacts

# Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

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
