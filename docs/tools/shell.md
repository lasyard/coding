# shell

## zsh 5.8 (x86_64-apple-darwin20.0)

```sh
${SHELL} --version
```

### Translate epoch timestamp

```sh
date -j -f "%s" "+%Y-%m-%d %H:%M:%S" 1607508959
date -j -f "%s" "+%y%m%d_%H%M%S" 1607508959
date -j -f "%y%m%d%H%M%S" "+%s" 170801000000
```

### Remove executable flags

```sh
sudo chmod -R -x photo
chmod -R +X photo
```
