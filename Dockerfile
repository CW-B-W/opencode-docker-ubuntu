FROM ubuntu:24.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

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

# Install dependencies and Node.js 22 from NodeSource
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installation
RUN node -v && npm -v

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
