FROM debian:bookworm-slim

ARG GHCUP_DWN_URL=https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup

ARG PATH
RUN test -n ${PATH}
ENV PATH=${PATH}
ENV LANG=C.UTF-8
ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1

RUN \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        curl \
        libnuma-dev \
        zlib1g-dev \
        libgmp-dev \
        libgmp10 \
        git \
        wget \
        lsb-release \
        software-properties-common \
        gnupg2 \
        apt-transport-https \
        gcc \
        autoconf \
        automake \
        libffi-dev \
        libffi8 \
        libgmp-dev \
        libgmp10 \
        libncurses-dev \
        libncurses5 \
        libtinfo5 \
        libblas3 \
        liblapack3 \
        liblapack-dev \
        libblas-dev \
        xz-utils \
        build-essential

# install gpg keys
ARG GPG_KEY=7784930957807690A66EBDBE3786C5262ECB4A3F
RUN gpg --batch --keyserver keys.openpgp.org --recv-keys $GPG_KEY

# install ghcup
RUN \
    curl ${GHCUP_DWN_URL} > /usr/bin/ghcup && \
    chmod +x /usr/bin/ghcup && \
    ghcup config set gpg-setting GPGStrict

ARG VERSION_GHC=9.8.1
ARG VERSION_CABAL=latest
ARG VERSION_STACK=latest

# install GHC, cabal and stack
RUN \
    ghcup -v install ghc --isolate /usr/local --force ${GHC} && \
    ghcup -v install cabal --isolate /usr/local/bin --force ${VERSION_CABAL} && \
    ghcup -v install stack --isolate /usr/local/bin --force ${VERSION_STACK} && \
    ghcup install hls

ARG USER_NAME=haskell
RUN useradd --no-log-init --create-home --shell /bin/bash ${USER_NAME}
WORKDIR /home/${USER_NAME}
