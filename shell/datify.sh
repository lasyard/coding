#!/usr/bin/env sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <FileName...>"
    exit 1
fi

for file in "$@"; do
    if [[ ${file} =~ [0-9]{10} ]]; then
        name="$(date -j -f "%s" "+%y%m%d_%H%M%S" "$(expr "${file%.*}" : "[^0-9]*\([0-9]\{10\}\)")")"."${file##*.}"
        echo "Rename \"${file}\" to \"${name}\"."
        mv "${file}" "${name}"
    fi
done
