#!/usr/bin/env bash
set -euo pipefail

if (( $# != 3 )); then
  echo "usage: $(basename $0) <name> <size (MB)> <number of files>" 1>&2
  exit 1
fi
NAME=$1
SIZE=$(echo $2 | numfmt --from=iec)
SIZEMB=$(echo "$SIZE/1024/1024" | bc)
NFILES=$3
PATH="$(pwd -P)/bin:${PATH}"

echo "== ${NFILES} random of size ${SIZE} B (${SIZEMB} MB)"
mkdir -p data/${NAME}
for i in $(seq 1 ${NFILES}); do
  FILENAME="data/${NAME}/rand.${i}.bin"
  echo "-- generating file ${FILENAME}"
  PASS=$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)
  dd if=<(openssl enc -aes-256-ctr -pass pass:"${PASS}" -nosalt </dev/zero 2>/dev/null) \
     of="${FILENAME}" bs=1M count=${SIZEMB} iflag=fullblock
  echo "-- computing XXH128 for file ${FILENAME}"
  xxh128sum ${FILENAME} > ${FILENAME}.xxh128
  cat ${FILENAME}.xxh128
done
