#!/usr/bin/env bash
set -euo pipefail

if (( $# < 2 )); then
    echo "usage: `basename $0` <rclone remote name> <dataset name> [<rclone options>]" 1>&2
    exit 1
fi
REMOTE="$1"
NAME="$2"
RCLONE_EXTRA="${@:3}"
PATH="$(pwd -P)/bin:${PATH}"

echo "-- uploading data to cloud (rclone remote ${REMOTE})"
echo "rclone extra args: ${RCLONE_EXTRA}"
rclone mkdir ${REMOTE}:cloud-benchmark
ulimit -n 10240 && rclone -vv --stats 1000ms --stats-one-line ${RCLONE_EXTRA} copy data/${NAME} ${REMOTE}:cloud-benchmark/data/${NAME}
