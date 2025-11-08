# syntax=docker.io/docker/dockerfile:1.4
FROM --platform=linux/riscv64 cartesi/python:3.13.2-slim-noble

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential cmake autotools-dev autoconf automake gfortran \
        gfortran-11 libgfortran-11-dev libgfortran5 pkg-config libopenblas-dev \
        liblapack-dev libffi-dev curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | bash -s -- -y

WORKDIR /opt/cartesi/dapp
