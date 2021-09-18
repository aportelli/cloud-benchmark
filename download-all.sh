#!/bin/env bash
set -euo pipefail

if (( $# < 2 )); then
    echo "usage: `basename $0` <rclone remote name> <dataset name> [<rclone options>]" 1>&2
    exit 1
fi
REMOTE="$1"
NAME="$2"
RCLONE_EXTRA="${@:3}"
PATH="$(pwd -P)/bin:${PATH}"

echo "-- downloading data from cloud (rclone remote ${REMOTE})"
rclone copy -vv --stats 1000ms --stats-one-line ${RCLONE_EXTRA} ${REMOTE}:cloud-benchmark/data/${NAME} download/data/${NAME}
echo '-- verifying checksums'
cd download
TMP=$(mktemp)
cat $(find data/${NAME} -name '*.xxh128') > ${TMP}
xxh128sum -c ${TMP}
rm -f ${TMP}
cd ..
