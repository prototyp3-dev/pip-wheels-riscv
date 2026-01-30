# syntax=docker.io/docker/dockerfile:1.4
# FROM --platform=linux/riscv64 cartesi/python:3.13.2-slim-noble
FROM --platform=linux/riscv64 cartesi/python:3.12.9-slim-noble

ARG APT_UPDATE_SNAPSHOT=20260113T030400Z
ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
set -eu
apt-get update
apt-get install -y --no-install-recommends ca-certificates
apt-get update --snapshot=${APT_UPDATE_SNAPSHOT}
apt-get remove -y --purge ca-certificates
apt-get autoremove -y --purge
EOF

RUN apt-get install -y --no-install-recommends \
        build-essential cmake autotools-dev autoconf automake gfortran \
        gfortran-11 libgfortran-11-dev libgfortran5 pkg-config libopenblas-dev \
        liblapack-dev libffi-dev curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | bash -s -- -y

RUN apt-get install -y --no-install-recommends \
        vim git ca-certificates libjpeg-dev zlib1g zlib1g-dev

WORKDIR /opt/cartesi/dapp
