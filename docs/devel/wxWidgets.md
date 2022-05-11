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

#### Release

```sh
cmake -S . -B build-x86_64-darwin-release -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~
cd build-x86_64-darwin-release
cmake --build . --target install
```

Add `RPATH` for `wxrc` on macOS

```sh
install_name_tool -add_rpath "@executable_path/../lib" ~/bin/wxrc
```

```sh
# `wx-config` is used by cmake to find wxWidgets on Unix-like system, so set the path.
export PATH="${PATH}:${HOME}/bin"
```

#### Debug

```sh
cmake -S . -B build-x86_64-darwin-debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/workspace/devel
cd build-x86_64-darwin-debug
cmake --build . --target install
```

The following steps is similar with Release Build.

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
