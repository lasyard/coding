#!/usr/bin/env sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <FileName...>"
    exit 1
fi

set +x

for file in "$@"; do
    if [[ ${file} =~ [0-9]{10} ]]; then
        tm="$(date -j -f "%s" "+%Y-%m-%dT%H:%M:%S" "$(expr "${file%.*}" : "[^0-9]*\([0-9]\{10\}\)")")"
        touch -cam -d "${tm}" "${file}"
        name="$(stat -f "%Sm" -t "%Y%m%d_%H%M%S" "${file}")"."${file##*.}"
        mv "${file}" "${name}"
        echo "Set mtime of \"${file}\" to ${tm} and rename to \"${name}\"."
    fi
done
