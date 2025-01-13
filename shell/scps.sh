#!/usr/bin/env sh

if [ $# -lt 3 ]; then
    echo "Usage: $0 <file> <target directory on remote host> <host...>"
    exit 1
fi

FILE="$1"
shift
TARGET_DIR="$1"
shift
HOST="$@"

echo "Copy ${FILE} to ${TARGET_DIR} on host ${HOST} ..."

echo "${HOST}" | tr ' ' '\n' | xargs -n 1 -P 0 -I "{}" scp "${FILE}" "{}:${TARGET_DIR}"

wait

echo "Done."
