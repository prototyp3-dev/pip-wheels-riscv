# Builder image for wheels

This directory contains a Dockerfile with the minimal requirements to build most of the wheels in this repository. To build the wheels, perform the following steps:

- Create the builder image:

```shell
docker build . --platform=linux/riscv64 -t riscv-builder:latest
```

- Build the wheel using this image, through an interactive shell or with a command like the following:

```shell
docker run --rm -it --platform=linux/riscv64 -v ./wheels:/wheels riscv-builder pip wheel -w /wheels <package>
```

- The resulting Wheel will be placed in the ./wheels directory. Now move it to the appropriate subdirectory in ../wheels and run the `build_index.py` script to update the .html.
