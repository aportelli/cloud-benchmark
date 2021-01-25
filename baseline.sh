#!/bin/env bash
set -e

PATH="$(pwd -P)/bin:${PATH}"
SERVERS=$(speedtest -L -f csv | grep -v ID | awk -F "," '{gsub("\"","",$1); printf("%s ", $1);}')
rm -f baseline.csv
for s in ${SERVERS}; do
  echo "-- testing server ${s}"
  speedtest -s ${s} -f csv >> baseline.csv
done
echo "-- summary"
echo ''
printf '%-12s %-12s %s\n' 'down (MB/s)' 'up (MB/s)' 'server'
echo '------------------------------------------------------------------'
awk -F "," '{gsub("\"","",$1); gsub("\"","",$6); gsub("\"","",$7); printf("%-12.2f %-12.2f %s\n", $6/1024/1024, $7/1024/1024, $1);}' baseline.csv
echo ''