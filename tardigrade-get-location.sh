#!/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
    echo "usage: `basename $0` <file>" 1>&2
    exit 1
fi
FILE=$1
PATH="$(pwd -P)/bin:${PATH}"

echo '-- getting tardigrade URL'
URL=$(uplink share --url  sj://lattice-cloud-benchmark/${FILE} | grep -E '^URL' | awk '{print $3}')
echo ${URL}
echo '-- getting pieces locations'
mkdir -p $(dirname tardigrade/${FILE})
LOC=$(mktemp)
curl -sL ${URL} | grep 'var routes' | grep -Eo '\[[^ ]+\]' > ${LOC}
sed -E 's/\[?\{"Latitude":([0-9.-]+),"Longitude":([0-9.-]+)\},?\]?/\1 \2\n/g' ${LOC} > tardigrade/${FILE}.loc.dat
rm -f ${LOC}
echo "locations saved in tardigrade/${FILE}.loc.dat"
