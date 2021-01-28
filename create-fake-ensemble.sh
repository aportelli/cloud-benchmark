#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
  echo "usage: $(basename $0) <L> <T>" 1>&2
  exit 1
fi
L=$1
T=$2
SIZE=$(echo "$L^3*$T*6*4*16" | bc)
SIZEMB=$(echo "$SIZE/1024/1024" | bc)
PATH="$(pwd -P)/bin:${PATH}"

echo "L = ${L} / T = ${T} / size = ${SIZE} B (${SIZEMB} MB)"
mkdir -p ensemble/L${L}_T${T}
for traj in $(seq 1800 20 2000); do
  FILENAME="ensemble/L${L}_T${T}/ckpoint_lat.${traj}"
  echo "-- generating file ${FILENAME}"
  PASS=$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)
  dd if=<(openssl enc -aes-256-ctr -pass pass:"${PASS}" -nosalt </dev/zero 2>/dev/null) \
     of="${FILENAME}" bs=1M count=${SIZEMB} iflag=fullblock
  echo "-- computing XXH128"
  xxh128sum ${FILENAME} > ${FILENAME}.xxh128
  cat ${FILENAME}.xxh128
done
