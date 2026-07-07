# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# ── System packages ───────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      curl \
      wget \
      git \
      unzip \
      zip \
      tar \
      xz-utils \
      ca-certificates \
      gnupg \
      apt-transport-https \
      ripgrep \
      fzf \
      fd-find \
      tidy \
      sqlite3 \
      libsqlite3-dev \
      python3 \
      python3-pip \
      python3-venv \
      luarocks \
      tzdata \
  && rm -rf /var/lib/apt/lists/*

# ── Neovim nightly ────────────────────────────────────────────────────────────
RUN ARCH=$(dpkg --print-architecture) \
  && case "${ARCH}" in \
       amd64) NVIM_ARCH="x86_64" ;; \
       arm64) NVIM_ARCH="arm64" ;; \
       *) echo "Unsupported arch: ${ARCH}" && exit 1 ;; \
     esac \
  && curl -LO "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-${NVIM_ARCH}.tar.gz" \
  && tar -xzf "nvim-linux-${NVIM_ARCH}.tar.gz" \
  && cp -a "nvim-linux-${NVIM_ARCH}/." /usr/local/ \
  && rm -rf "nvim-linux-${NVIM_ARCH}" "nvim-linux-${NVIM_ARCH}.tar.gz"

# ── Node.js LTS ───────────────────────────────────────────────────────────────
ARG NODE_MAJOR=22
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && corepack enable \
  && rm -rf /var/lib/apt/lists/*

# ── Go ────────────────────────────────────────────────────────────────────────
ARG GO_VERSION=1.23.8
RUN ARCH=$(dpkg --print-architecture) \
  && curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" \
  && tar -C /usr/local -xzf "go${GO_VERSION}.linux-${ARCH}.tar.gz" \
  && rm "go${GO_VERSION}.linux-${ARCH}.tar.gz"
ENV GOPATH=/root/go
ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"

# ── Java 21 (Eclipse Temurin) ─────────────────────────────────────────────────
RUN curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
      | gpg --dearmor -o /usr/share/keyrings/adoptium.gpg \
  && . /etc/os-release \
  && echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb ${VERSION_CODENAME} main" \
      > /etc/apt/sources.list.d/adoptium.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends temurin-21-jdk \
  && ln -sf "$(dirname "$(dirname "$(readlink -f "$(which java)")")")" /usr/local/java \
  && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/local/java
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# ── Maven ─────────────────────────────────────────────────────────────────────
ARG MAVEN_VERSION=3.9.9
RUN curl -LO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
  && tar -xzf "apache-maven-${MAVEN_VERSION}-bin.tar.gz" -C /opt \
  && ln -s "/opt/apache-maven-${MAVEN_VERSION}/bin/mvn" /usr/local/bin/mvn \
  && rm "apache-maven-${MAVEN_VERSION}-bin.tar.gz"

# ── Gradle ────────────────────────────────────────────────────────────────────
ARG GRADLE_VERSION=8.12
RUN curl -LO "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
  && unzip -q "gradle-${GRADLE_VERSION}-bin.zip" -d /opt \
  && ln -s "/opt/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle \
  && rm "gradle-${GRADLE_VERSION}-bin.zip"

# ── Rust ──────────────────────────────────────────────────────────────────────
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | sh -s -- -y --no-modify-path --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

# ── Neovim configuration ──────────────────────────────────────────────────────
COPY . /root/.config/nvim/

# ── Bootstrap plugins via lazy.nvim (includes all post-install build steps) ───
RUN HOME=/root nvim --headless "+Lazy! sync" "+qa" 2>&1 | tail -10 || true

WORKDIR /workspace
ENTRYPOINT ["nvim"]
