#!/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
    echo "usage: `basename $0` <rclone remote name>" 1>&2
    exit 1
fi
REMOTE="$1"
CPUS=$(nproc --all || echo 4)
PATH="$(pwd -P)/bin:${PATH}"

echo "-- downloading data from cloud (rclone remote ${REMOTE})"
ulimit -n 10240 && rclone copy -vv --stats 1000ms --stats-one-line --transfers ${CPUS} "${REMOTE}":lattice-cloud-benchmark/ensemble download/ensemble
echo '-- verifying checksums'
cd download
TMP=$(mktemp)
cat $(find ensemble -name '*.xxh128') > ${TMP}
xxh128sum -c ${TMP}
rm -f ${TMP}
cd ..

