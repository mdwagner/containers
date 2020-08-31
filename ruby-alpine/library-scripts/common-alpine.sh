#!/bin/ash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Syntax: ./common-alpine.sh <username> <user UID> <user GID>

USERNAME=${1:-"vscode"}
USER_UID=${2:-1000}
USER_GID=${3:-1000}

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run a root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Install git, bash, dependencies, and add a non-root user
apk add --no-cache \
    git \
    openssh-client \
    less \
    bash \
    libgcc \
    libstdc++ \
    curl \
    wget \
    unzip \
    nano \
    jq \
    gnupg \
    procps \
    coreutils \
    ca-certificates \
    krb5-libs \
    libintl \
    tzdata \
    userspace-rcu \
    zlib \
    make \
    cmake \
    build-base \
    ncurses-dev \
    imagemagick

PREVIOUS_DIR=$PWD
TMP_FISH_SHELL=/tmp/fish-shell

git clone --depth 1 --branch 3.1.2 https://github.com/fish-shell/fish-shell.git $TMP_FISH_SHELL
cd $TMP_FISH_SHELL
cmake .
make
make install
ln -s $(which fish) /bin/fish
echo '/bin/fish' >> /etc/shells
cd $PREVIOUS_DIR
rm -rf $TMP_FISH_SHELL

# Create user
addgroup -g $USER_GID $USERNAME
adduser -D -s /bin/fish -u $USER_UID -G $USERNAME $USERNAME

# Add add sudo support for non-root user
apk add --no-cache sudo
echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME

# Ensure ~/.local/bin is in the PATH for root and non-root users for bash.
echo "export PATH=\$PATH:\$HOME/.local/bin" | tee -a /root/.bashrc >> /home/$USERNAME/.bashrc
chown $USER_UID:$USER_GID /home/$USERNAME/.bashrc

su vscode -c "set -U fish_user_paths /usr/local/bundle/bin /usr/local/sbin /usr/local/bin /usr/sbin /sbin \$HOME/.local/bin \$fish_user_paths"

echo "Done!"
