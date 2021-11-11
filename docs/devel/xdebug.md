# xdebug

## 3.1.1

```sh
export ver="3.1.1"
```

### Download source

```sh
wget https://xdebug.org/files/xdebug-${ver}.tgz

tar -C ~/workspace/devel/ -xzf xdebug-${ver}.tgz
cd ~/workspace/devel/xdebug-${ver}
```

### Build

```sh
phpize
./configure
make
```
