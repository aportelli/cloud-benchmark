#!/usr/bin/env bash
set -euo pipefail

if (( $# != 3 )); then
    echo "usage: `basename $0` <output directory> <rclone remote name> <chunk size>" 1>&2
    exit 1
fi
DIR=$1
REMOTE=$2
SIZE=$3
PATH="$(pwd -P)/bin:${PATH}"

mkdir -p ${DIR}
#./baseline.sh |& tee ${DIR}/baseline.log
#mv baseline.csv ${DIR}/
./download-all-chunked.sh ${REMOTE} ${SIZE} |& tee ${DIR}/download-chunked-${SIZE}.log
./download-all.sh ${REMOTE} |& tee ${DIR}/download.log
