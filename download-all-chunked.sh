#!/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
    echo "usage: `basename $0` <rclone remote name>" 1>&2
    exit 1
fi
REMOTE="$1"
CPUS=$(nproc || echo 4)
PATH="$(pwd -P)/bin:${PATH}"

echo "-- downloading data from cloud (rclone remote ${REMOTE})"
ulimit -n 10240 && rclone copy -vv --stats 1000ms --stats-one-line --transfers ${CPUS} "${REMOTE}":lattice-cloud-benchmark/ensemble-chunked download/ensemble-chunked
echo '-- recontructing files'
cd download
for f in $(find ensemble-chunked -name '*.xxh128'); do
  STEM=${f//.xxh128}
  echo ${STEM}
  cat $(find ensemble-chunked -name "$(basename ${STEM}).*" | grep -v xxh | sort) > ${STEM}
done
echo '-- verifying checksums'
TMP=$(mktemp)
cat $(find ensemble-chunked -name '*.xxh128') | sed 's/ensemble/ensemble-chunked/g' > ${TMP}
xxh128sum -c ${TMP}
rm -f ${TMP}
cd ..
