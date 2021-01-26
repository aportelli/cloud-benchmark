#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
    echo "usage: `basename $0` <rclone remote name> <chunk size>" 1>&2
    exit 1
fi
REMOTE="$1"
SIZE=$2
CPUS=$(nproc --all || echo 4)
PATH="$(pwd -P)/bin:${PATH}"

echo "-- uploading data to cloud (rclone remote ${REMOTE})"
rclone mkdir "${REMOTE}":lattice-cloud-benchmark
rclone -vv --stats 1000ms --stats-one-line --transfers ${CPUS} copy ensemble-chunked/${SIZE} "${REMOTE}":lattice-cloud-benchmark/ensemble-chunked/${SIZE} 

