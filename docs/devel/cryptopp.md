# cryptopp

## 8.6

```bash
export ver="860"
```

### Download source

```bash
wget https://www.cryptopp.com/cryptopp${ver}.zip
wget https://www.cryptopp.com/cryptopp${ver}.zip.sig
```

### Build (macOS Big Sur)

#### Release

```bash
unzip -d ~/workspace/devel/cryptopp${ver}-x86_64-darwin-release cryptopp${ver}.zip
cd ~/workspace/devel/cryptopp${ver}-x86_64-darwin-release
```

```bash
make all
# Fix dylib id
install_name_tool -id $(pwd)/libcryptopp.dylib libcryptopp.dylib
```

### Build (MSYS2)

#### Release

```bash
unzip -d ~/workspace/devel/cryptopp${ver}-x86_64-mingw-release cryptopp${ver}.zip
cd ~/workspace/devel/cryptopp${ver}-x86_64-mingw-release
```

```bash
make all
```
