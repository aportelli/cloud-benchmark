#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
    echo "usage: `basename $0` <name> <access grant>" 1>&2
    exit 1
fi
NAME=$1
GRANT=$2
PATH="$(pwd -P)/bin:${PATH}"

rclone config create ${NAME} tardigrade access_grant $(cat ${GRANT})
