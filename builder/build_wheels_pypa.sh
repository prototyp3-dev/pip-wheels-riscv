#!/bin/bash
set -e -u -x

project=${1:-.}
min_version=${2:-}

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w wheelhouse/
    fi
}

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [ ! -z "min_version" ]; then
        is_less=$("${PYBIN}/python" -c "from packaging.version import Version;import platform; print(Version(platform.python_version()) < Version('$min_version'))")
        if [ "$is_less" = "True" ]; then
            continue
        fi
    fi
    PIP_CACHE_DIR=cache "${PYBIN}/pip3" wheel $project --no-deps -w wheelhouse
done
                                                  
# Bundle external shared libraries into the wheels
project_tag=$(echo $project | sed 's/==/-/')
for whl in wheelhouse/$project_tag*.whl; do
    repair_wheel "$whl"
done
