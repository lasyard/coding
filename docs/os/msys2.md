# MSYS2

## 20211130

### pacman

```sh
# upgrade
pacman -Syu
```

In MinGW

```sh
pacman -S --needed zip
pacman -S --needed unzip
pacman -S --needed vim
```

```sh
pacman -S --needed ${MINGW_PACKAGE_PREFIX}-jq
```

```sh
pacman -S --needed base-devel
pacman -S --needed ${MINGW_PACKAGE_PREFIX}-toolchain
```

```sh
pacman -S --needed ${MINGW_PACKAGE_PREFIX}-libjpeg-turbo
pacman -S --needed ${MINGW_PACKAGE_PREFIX}-libpng
pacman -S --needed ${MINGW_PACKAGE_PREFIX}-libtiff
```
