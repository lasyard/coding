#!/usr/bin/env sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 <source dir> <target dir> <extra options for rsync>"
    echo "Useful extra options: --delete"
    echo "                      --ignore-existing"
    exit 1
fi

SOURCE_DIR="$1"
shift
TARGET_DIR="$1"
shift
EXTRA_OPTS="$@"

SOURCE_PATH="$(dirname "${SOURCE_DIR}")"
DIR="$(basename "${SOURCE_DIR}")"

if [ "${SOURCE_PATH}" = '.' ]; then
    SOURCE_PATH=
else
    SOURCE_PATH="${SOURCE_PATH}/"
fi

RSYNC_ARGS="--exclude=.* -RvrutO ${EXTRA_OPTS} --modify-window=3"
# --iconv support start from rsync 3.x
if [ $(rsync --version | head -n 1 | grep '\d\+' -o | head -n 1) -ge 3 ]; then
    RSYNC_ARGS="${RSYNC_ARGS} --iconv=utf-8-mac,utf-8"
fi

# dry run
# shellcheck disable=SC2086
rsync -n ${RSYNC_ARGS} "${SOURCE_PATH}./${DIR}" "${TARGET_DIR}"

# shellcheck disable=SC2039
read -rp "Do you want to sync up? (y/N)" ans
if [ "${ans}" = 'y' ] || [ "${ans}" = 'Y' ]; then
    # shellcheck disable=SC2086
    rsync ${RSYNC_ARGS} "${SOURCE_PATH}./${DIR}" "${TARGET_DIR}"
fi
