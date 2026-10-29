FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=user-devpod
# Usually 1000, but can be customized; ideally it should match the host id, to avoid permission errors on using mounted stuff
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Install basic packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
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
    zsh
RUN rm -rf /var/lib/apt/lists/*

# Create a non-root development user
RUN if getent group "${USER_GID}" >/dev/null; then \
        groupmod -n "${USERNAME}" "$(getent group "${USER_GID}" | cut -d: -f1)"; \
    else \
        groupadd --gid "${USER_GID}" "${USERNAME}"; \
    fi
# Base images may already ship a user with this UID (e.g. "ubuntu"): rename it instead of failing
RUN existing="$(getent passwd "${USER_UID}" | cut -d: -f1)"; \
    if [ -n "${existing}" ]; then \
        usermod --login "${USERNAME}" --home "/home/${USERNAME}" --move-home \
            --gid "${USER_GID}" --shell /usr/bin/zsh "${existing}"; \
    else \
        useradd --uid "${USER_UID}" --gid "${USER_GID}" --create-home \
            --shell /usr/bin/zsh "${USERNAME}"; \
    fi
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && chsh -s /usr/bin/zsh

# Switch to non-root user
USER ${USERNAME}
ENV HOME=/home/${USERNAME}

# Clone and setup dotfiles (some programs are already installed here, but will be try-installed in the install.sh anyway)
ENV DOTFILES_REPO="https://github.com/igng/dotfiles.git"
ENV DOTFILES_DIR=${HOME}/dotfiles
RUN git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
WORKDIR ${DOTFILES_DIR}
RUN ./install.sh
