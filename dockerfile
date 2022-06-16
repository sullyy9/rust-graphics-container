FROM rust:latest

ARG DEBIAN_FRONTEND=noninteractive

# Need this to get access to the latest version of mesa opengl.
RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" | tee -a /etc/apt/sources.list

RUN apt update && \
    apt -y upgrade && \
    apt -y install \
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


RUN rustup target add x86_64-pc-windows-gnu && \
    cargo install cargo-expand && \
    cargo install cargo-modules && \
    rustup component add rust-src && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -o /usr/bin/rust-analyzer.gz && \
    gzip -d /usr/bin/rust-analyzer.gz && \
    chmod 755 /usr/bin/rust-analyzer

ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib