#!/usr/bin/env bash

if ! command -v exiftool >/dev/null; then
    echo "Cannot find exiftool. See <https://exiftool.org/>."
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 <source dir> <target dir>"
    exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

FILE_NAME="${TARGET_DIR}/\
\${DateTimeOriginal#;DateFmt('%Y/p%Y%m')}/\${DateTimeOriginal#;DateFmt('%Y%m%d_%H%M%S')}_\
\${HierarchicalSubject;\$_=join('_',map{my @w=split /\|/;\$w[-1]}sort(split /,/))}_\
\${Model;tr/ /_/}%+3c.jpg"

exiftool -fast2 -ext jpg -if '${DateTimeOriginal} and ${HierarchicalSubject} and ${Model}' -P -m \
    -PreviewImage= -iptc:all= -xmp:all= \
    "-xmp:HierarchicalSubject<\${HierarchicalSubject}" \
    "-xmp:Subject<\${Subject}" \
    "-xmp:Rating<\${Rating;\$_=\$_?\$_:undef}" \
    -sep ',' "-FileName<${FILE_NAME}" -R "${SOURCE_DIR}" -overwrite_original
