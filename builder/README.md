# Builder image for wheels

This directory contains a Dockerfile with the minimal requirements to build most of the wheels in this repository. To build the wheels, perform the following steps:

- Create the builder image:

```shell
docker build . --platform=linux/riscv64 -t riscv-builder
```

- Build the wheel using this image, through an interactive shell or with a command like the following:

```shell
docker run --rm -it --platform=linux/riscv64 -v $PWD:/opt/build -w /opt/build -u $(id -u):$(id -g) riscv-builder PIP_CACHE_DIR=/opt/build/cache pip wheel -w /opt/build/wheelhouse <package>
```

- The resulting Wheel will be placed in the ./wheelhouse directory. Now move it to the appropriate subdirectory in ../wheelhouse and run the `build_index.py` script to update the .html.

You can then transfer the generated wheels to the dist place to build the index:

```shell
./transfer_files.sh -r
```
