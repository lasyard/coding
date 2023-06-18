# jasper

## 4.0.0

```sh
export ver="4.0.0"
```

### Download source

```sh
wget https://github.com/jasper-software/jasper/releases/download/version-${ver}/jasper-${ver}.tar.gz
```

### Build (macOS, CMake 3.26.4)

#### Debug

```sh
tar -C ~/workspace/devel -xzf jasper-${ver}.tar.gz
cd ~/workspace/devel/jasper-${ver}
```

```sh
cmake -S . -B build-x86_64-darwin-debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/workspace/devel
cd build-x86_64-darwin-debug
cmake --build . --target install
```

### Build (Win10, VS 2022)

```sh
tar -C ~/workspace/devel -xzf jasper-${ver}.tar.gz
cd ~/workspace/devel/jasper-${ver}
```

In Developer Command Prompt for VS 2022

```bat
cmake -G "Visual Studio 17 2022" -A x64 -S . -B build-x86_64-win-debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=D:\workspace\devel
cd build-x86_64-win-debug
msbuild INSTALL.vcxproj
```
