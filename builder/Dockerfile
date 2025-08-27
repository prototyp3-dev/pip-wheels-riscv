# syntax=docker.io/docker/dockerfile:1.4
FROM --platform=linux/riscv64 cartesi/python:3.10-slim-jammy

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential cmake autotools-dev autoconf automake gfortran \
        gfortran-11 libgfortran-11-dev libgfortran5 pkg-config libopenblas-dev \
        liblapack-dev libffi-dev

WORKDIR /opt/cartesi/dapp
