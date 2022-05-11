# cryptopp

## 8.6

```sh
export ver="860"
```

### Download source

```sh
wget https://www.cryptopp.com/cryptopp${ver}.zip
wget https://www.cryptopp.com/cryptopp${ver}.zip.sig
```

### Build (macOS Big Sur)

#### Release

```sh
unzip -d ~/workspace/devel/cryptopp${ver}-x86_64-darwin-release cryptopp${ver}.zip
cd ~/workspace/devel/cryptopp${ver}-x86_64-darwin-release
```

```sh
make all
make install PREFIX=~
```

Do this if you do not want to install

```sh
# Fix dylib id
install_name_tool -id $(pwd)/libcryptopp.dylib libcryptopp.dylib
```

#### Debug

```sh
unzip -d ~/workspace/devel/cryptopp${ver}-x86_64-darwin-debug cryptopp${ver}.zip
cd ~/workspace/devel/cryptopp${ver}-x86_64-darwin-debug
```

```sh
export CXXFLAGS="-DDEBUG -g -O0"
make all
make install PREFIX=~/workspace/devel
```

### Build (MSYS2)

#### Release

```sh
unzip -d ~/workspace/devel/cryptopp${ver}-x86_64-mingw-release cryptopp${ver}.zip
cd ~/workspace/devel/cryptopp${ver}-x86_64-mingw-release
```

```sh
make all
```
