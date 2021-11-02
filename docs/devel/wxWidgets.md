# wxWidgets

## 3.1.5

```bash
export ver="3.1.5"
```

### Download source

```bash
wget https://github.com/wxWidgets/wxWidgets/releases/download/v${ver}/wxWidgets-${ver}.tar.bz2

tar -C ~/workspace/devel/ -xjf wxWidgets-${ver}.tar.bz2
cd ~/workspace/devel/wxWidgets-${ver}
```

### Build (macOS Big Sur)

#### Debug

```bash
mkdir build-x86_64-darwin-debug
cd build-x86_64-darwin-debug
../configure --enable-debug
make
```

#### Release

```bash
mkdir build-x86_64-darwin-release
cd build-x86_64-darwin-release
../configure
make
```

### Build (MSYS2)

#### Debug

```bash
mkdir build-x86_64-mingw-debug
cd build-x86_64-mingw-debug
../configure --with-msw --enable-debug --disable-precomp-headers
make
```

#### Release

```bash
mkdir build-x86_64-mingw-release
cd build-x86_64-mingw-release
../configure --with-msw --disable-precomp-headers
make
```
