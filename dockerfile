FROM rust:latest

ARG DEBIAN_FRONTEND=noninteractive

# Need this to get access to the latest version of mesa opengl.
RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" | tee -a /etc/apt/sources.list

RUN apt update && \
    apt -y upgrade && \
    apt -y install \
        sudo \
        mingw-w64 \
        g++ \
        pkg-config \
        libxcursor1 \
        libxrandr2 \
        libxi6 \
        libx11-xcb1 \
        libglfw3 \
        libegl1 \
        libpci3 \
        libxkbcommon0 \
        mesa-utils

# Setup default user
ENV USER=developer
RUN useradd --create-home -s /bin/bash -m $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN rustup target add x86_64-pc-windows-gnu && \
    cargo install cargo-expand && \
    cargo install cargo-modules && \
    rustup component add rust-src && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -o /usr/bin/rust-analyzer.gz && \
    gzip -d /usr/bin/rust-analyzer.gz && \
    chown -R developer:developer /usr/bin/rust-analyzer && \
    chmod 775 /usr/bin/rust-analyzer && \
    chown -R developer:developer /usr/local/cargo/

ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

WORKDIR /home/$USER
USER $USER
