# exiftool

## 12.30

```sh
exiftool -ver
```

### Move files

```sh
exiftool -fast2 -ext jpg -if '${DateTimeOriginal} and ${Keywords} and ${Model}' -d '%Y/%Y%m/%Y%m%d_%H%M%S' "-FileName<${HOME}/Pictures/photo/\${DateTimeOriginal}_\${Keywords;s/, /_/}_\${Model;tr/ /_/}%+.3nc.jpg" *.jpg
exiftool -fast2 -ext jpg -if '${DateTimeOriginal} and ${Keywords} and not ${Model}' -d '%Y/%Y%m/%Y%m%d_%H%M%S' "-FileName<${HOME}/Pictures/photo/\${DateTimeOriginal}_\${Keywords;s/, /_/}%+.3nc.jpg" *.jpg
```

### Modify time

```sh
# take file modification time as time
exiftool -ext jpg -if 'not ${DateTimeOriginal}' '-AllDates<FileModifyDate' −overwrite_original *.jpg
# set specified time if no time
exiftool -ext jpg -if 'not ${DateTimeOriginal}' '-AllDates=2020:02:02 20:20:20' −overwrite_original *.jpg
# set specified time
exiftool -ext jpg '-AllDates=2020:02:02 20:20:20' −overwrite_original *.jpg
# set time to one day before
exiftool -ext jpg -if '${DateTimeOriginal}' -DateTimeOriginal-='1 00:00:00' −overwrite_original *.jpg
```
