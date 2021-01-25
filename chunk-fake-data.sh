#!/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
    echo "usage: `basename $0` <chunk size>" 1>&2
    exit 1
fi
SIZE=$1

INITDIR=$(pwd)
for f in $(find ensemble -name 'ckpoint_lat.*' | grep -v xxh128); do
  echo "-- chunking ${f}"
  CDIR=$(dirname ${f} | sed "s/ensemble/ensemble-chunked\/${SIZE}/g")
  mkdir -p ${CDIR}
  cd ${CDIR}
  cp ${INITDIR}/${f}.xxh128 .
  split --verbose -a 4 -b ${SIZE} -d "${INITDIR}/${f}" "$(basename ${f})."
  cd ${INITDIR}
done

