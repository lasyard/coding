#!/usr/bin/env sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <FileName...>"
    exit 1
fi

require() {
    if ! command -v "$1" >/dev/null; then
        echo "\"$1\" is not installed." >&2
        exit 1
    fi
}

require "mediainfo"
require "jq"

for file in "$@"; do
    if [ ! -f "${file}" ]; then
        echo "File ${file} does not exist."
        continue
    fi

    TRACKS=$(mediainfo --Output=JSON "${file}" | jq '.media.track')

    GENERAL=$(echo "${TRACKS}" | jq -r '.[]|select(."@type"=="General")')
    FILE_SIZE=$(echo "${GENERAL}" | jq -r '.FileSize')
    DURATION=$(echo "${GENERAL}" | jq -r '.Duration')

    VIDEO_TRACK=$(echo "${TRACKS}" | jq '.[]|select(."@type"=="Video")')
    # DURATION=$(echo "${VIDEO_TRACK}" | jq -r '.Duration')
    WIDTH=$(echo "${VIDEO_TRACK}" | jq -r '.Width')
    HEIGHT=$(echo "${VIDEO_TRACK}" | jq -r '.Height')

    echo "${file}: size=${FILE_SIZE}, duration=${DURATION}, width=${WIDTH}, height=${HEIGHT}"
done
