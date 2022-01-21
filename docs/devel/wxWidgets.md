# wxWidgets

## 3.1.5

```sh
export ver="3.1.5"
```

### Download source

```sh
wget https://github.com/wxWidgets/wxWidgets/releases/download/v${ver}/wxWidgets-${ver}.tar.bz2

tar -C ~/workspace/devel/ -xjf wxWidgets-${ver}.tar.bz2
cd ~/workspace/devel/wxWidgets-${ver}
```

### Build (CMake 3.22.1)

```sh
cmake . -DCMAKE_INSTALL_PREFIX=~/workspace/devel
cmake --build . --target install
```

```sh
# `wx-config` is used by cmake to find wxWidgets on Unix-like system, so set the path.
export PATH="${PATH}:${HOME}/workspace/devel/bin"
```

### Build (macOS Big Sur)

#### Debug

```sh
mkdir build-x86_64-darwin-debug
cd build-x86_64-darwin-debug
../configure --enable-debug
make
```

#### Release

```sh
mkdir build-x86_64-darwin-release
cd build-x86_64-darwin-release
../configure
make
```

### Build (MSYS2)

#### Debug

```sh
mkdir build-x86_64-mingw-debug
cd build-x86_64-mingw-debug
../configure --with-msw --enable-debug --disable-precomp-headers
make
```

#### Release

```sh
mkdir build-x86_64-mingw-release
cd build-x86_64-mingw-release
../configure --with-msw --disable-precomp-headers
make
```
