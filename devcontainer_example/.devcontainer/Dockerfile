FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=user-devpod
ARG USER_UID=1002
ARG USER_GID=${USER_UID}

# Install basic packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        btop \
        build-essential \
        ca-certificates \
        curl \
        git \
        make \
        openssh-client \
        stow \
        sudo \
        tmux \
        unzip \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root development user.
RUN if getent group "${USER_GID}" >/dev/null; then \
        groupmod -n "${USERNAME}" "$(getent group "${USER_GID}" | cut -d: -f1)"; \
    else \
        groupadd --gid "${USER_GID}" "${USERNAME}"; \
    fi \
    && useradd \
        --uid "${USER_UID}" \
        --gid "${USER_GID}" \
        --create-home \
        --shell /usr/bin/zsh \
        "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && chsh -s /usr/bin/zsh \
    && chsh -s /usr/bin/zsh ${USERNAME}

ENV HOME=/home/${USERNAME}
USER ${USERNAME}

# Setup neovim
RUN mkdir -p "$HOME"/neovim
WORKDIR "$HOME"/neovim
RUN wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
RUN chmod u+x nvim-linux-x86_64.appimage
RUN ./nvim-linux-x86_64.appimage --appimage-extract
RUN sudo ln -s "${HOME}"/neovim/squashfs-root/usr/bin/nvim /usr/bin/nvim 

## Clone example project
# RUN mkdir -p "$HOME"/projects/example
# WORKDIR "$HOME"/projects/example
# RUN --mount=type=ssh,uid=1002,gid=1002,mode=0600 \
#     --mount=type=secret,id=known_hosts,target=/host-known-hosts,uid=1002,gid=1002,mode=0444,required=true \
#     GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/host-known-hosts -o StrictHostKeyChecking=yes" \
#     git clone git@path_to_project.git
