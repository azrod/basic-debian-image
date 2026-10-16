FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    libatomic1 \
    libstdc++6 \
    libgcc-s1 \
    zlib1g \
    libssl3 \
    libffi8 \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash user

# Passwordless sudo apt permits effective root access through APT's extensible hooks and options.
RUN printf '%s\n' 'user ALL=(root) NOPASSWD: /usr/bin/apt' > /etc/sudoers.d/user-apt \
    && chmod 0440 /etc/sudoers.d/user-apt

RUN install --directory --owner=user --group=user /data
WORKDIR /data
USER user
ENV PATH="/home/user/.local/bin:${PATH}"
RUN curl -fsSL https://mise.run | sh
RUN mise activate bash >> ~/.bashrc
