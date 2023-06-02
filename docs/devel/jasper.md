# jasper

## 4.0.0

```sh
export ver="4.0.0"
```

### Download source

```sh
wget https://github.com/jasper-software/jasper/releases/download/version-${ver}/jasper-${ver}.tar.gz

tar -C ~/workspace/devel -xzf jasper-${ver}.tar.gz
```

### Build (macOS, CMake 3.26.4)

#### Debug

```sh
cd jasper-${ver}

cmake -S . -B build-x86_64-darwin-debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/workspace/devel
cd build-x86_64-darwin-debug
cmake --build . --target install
```
