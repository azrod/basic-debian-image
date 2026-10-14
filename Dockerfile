FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash user

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo \
    && rm -rf /var/lib/apt/lists/*

# Passwordless sudo apt permits effective root access through APT's extensible hooks and options.
RUN printf '%s\n' 'user ALL=(root) NOPASSWD: /usr/bin/apt' > /etc/sudoers.d/user-apt \
    && chmod 0440 /etc/sudoers.d/user-apt

USER user
ENV PATH="/home/user/.local/bin:${PATH}"
RUN curl -fsSL https://mise.run | sh

