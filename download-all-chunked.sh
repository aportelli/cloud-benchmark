#!/bin/env bash
set -euo pipefail

if (( $# < 3 )); then
    echo "usage: `basename $0` <rclone remote name> <dataset name> <chunk size> [<rclone options>]" 1>&2
    exit 1
fi
REMOTE="$1"
NAME="$2"
SIZE="$3"
RCLONE_EXTRA="${@:4}"
PATH="$(pwd -P)/bin:${PATH}"

echo "-- downloading data from cloud (rclone remote ${REMOTE})"
rclone copy -vv --stats 1000ms --stats-one-line ${RCLONE_EXTRA} "${REMOTE}":cloud-benchmark/data/chunked/${SIZE}/${NAME} download/data/chunked/${SIZE}/${NAME}
echo '-- recontructing files'
cd download
for f in $(find data/chunked/${SIZE}/${NAME} -name '*.xxh128'); do
  STEM=${f//.xxh128}
  echo ${STEM}
  cat $(find data/chunked/${SIZE}/${NAME} -name "$(basename ${STEM}).*" | grep -v xxh | sort) > ${STEM}
done
echo '-- verifying checksums'
TMP=$(mktemp)
cat $(find data/chunked/${SIZE}/${NAME} -name '*.xxh128') | sed "s/data/data\/chunked\/${SIZE}/g" > ${TMP}
xxh128sum -c ${TMP}
rm -f ${TMP}
cd ..
