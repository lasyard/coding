# exiftool

## 12.30

```sh
exiftool -ver
```

### Move files

```sh
exiftool -fast2 -ext jpg -if '${DateTimeOriginal} and ${Keywords} and ${Model}' "-FileName<${HOME}/Pictures/photo/\${DateTimeOriginal#;DateFmt('%Y/%Y%m')}/\${Model;tr/ /_/}/\${DateTimeOriginal#;DateFmt('%Y%m%d_%H%M%S')}_\${Keywords;s/, /_/g}%+3c.jpg" *.jpg
```

### Modify time

```sh
# take file modification time as time
exiftool -ext jpg -if 'not ${DateTimeOriginal}' '-AllDates<FileModifyDate' −overwrite_original *.jpg
# set specified time if no time
exiftool -ext jpg -if 'not ${DateTimeOriginal}' '-AllDates=2002:02:02 02:02:02' −overwrite_original *.jpg
# set specified time
exiftool -ext jpg '-AllDates=2020:02:02 20:20:20' −overwrite_original *.jpg
exiftool -ext jpg "-AllDates=$(date -j -f "%s" "+%Y:%m:%d %H:%M:%S" 1012586522)" −overwrite_original *.jpg
# set time to one day before
exiftool -ext jpg -if '${DateTimeOriginal}' -DateTimeOriginal-='1 00:00:00' −overwrite_original *.jpg
```

### Modify Camera Model

```sh
exiftool -ext jpg -if 'not ${Model}' '-Model=UNKNOWN' -overwrite_original *.jpg
```
