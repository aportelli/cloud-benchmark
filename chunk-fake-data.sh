#!/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
    echo "usage: `basename $0` <name> <chunk size>" 1>&2
    exit 1
fi
NAME=$1
SIZE=$2

INITDIR=$(pwd)
for f in $(find data/${NAME} -name 'rand.*' | grep -v xxh128); do
  echo "-- chunking ${f}"
  CDIR=$(dirname ${f} | sed "s/data/data\/chunked\/${SIZE}/g")
  mkdir -p ${CDIR}
  cd ${CDIR}
  cp ${INITDIR}/${f}.xxh128 .
  split --verbose -a 4 -b ${SIZE} -d "${INITDIR}/${f}" "$(basename ${f})."
  cd ${INITDIR}
done

