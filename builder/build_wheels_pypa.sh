#!/bin/bash
set -e -u -x

project=${1:-.}
eq_version_prefix='=='
min_version=${2:-}
PLAT=${PLAT:-musllinux_1_2_riscv64}
WHEELHOUSE_DIR=${WHEELHOUSE_DIR:-wheelhouse}
PIP_CACHE_DIR=${PIP_CACHE_DIR:-cache}

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w $WHEELHOUSE_DIR/
    fi
}

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [ ! -z "$min_version" ]; then
        if [[ "$min_version" == "$eq_version_prefix"* ]]; then
            v=$(echo $min_version | sed 's/==//')
            is_eq=$("${PYBIN}/python" -c "from packaging.version import Version;import platform; print(Version(platform.python_version()).release[:len(Version('$v').release)] == Version('$v').release)")
            if [ "$is_eq" = "False" ]; then
                continue
            fi
        else
            is_less=$("${PYBIN}/python" -c "from packaging.version import Version;import platform; print(Version(platform.python_version()) < Version('$min_version'))")
            if [ "$is_less" = "True" ]; then
                continue
            fi
        fi
    fi
    PIP_CACHE_DIR=$PIP_CACHE_DIR "${PYBIN}/pip3" wheel $project --no-deps --find-links $WHEELHOUSE_DIR -w $WHEELHOUSE_DIR
done
                                                  
# Bundle external shared libraries into the wheels
project_tag=$(echo $project | sed 's/-/_/' | sed 's/==/-/')
for whl in $WHEELHOUSE_DIR/$project_tag*.whl; do
    repair_wheel "$whl"
done
