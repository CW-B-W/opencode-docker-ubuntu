FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bash \
        ripgrep \
        unzip \
        git \
        libgcc-s1 \
        libstdc++6 \
        tini \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Node.js for npm/npx
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="/root/.bun/bin:$PATH"

# uv for uvx (Python package runner)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

RUN curl -fsSL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

RUN opencode --version

WORKDIR /root

ENTRYPOINT ["/usr/bin/tini", "--", "opencode"]
