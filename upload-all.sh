#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
    echo "usage: `basename $0` <rclone remote name>" 1>&2
    exit 1
fi
REMOTE="$1"
CPUS=$(nproc || echo 4)
PATH="$(pwd -P)/bin:${PATH}"

echo "-- uploading data to cloud (rclone remote ${REMOTE})"
rclone mkdir "${REMOTE}":lattice-cloud-benchmark
rclone -vv --stats 1000ms --stats-one-line --transfers ${CPUS} copy ensemble "${REMOTE}":lattice-cloud-benchmark/ensemble

