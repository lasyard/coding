# gpg

## 2.3.3

```sh
gpg --version
```

```sh
gpg --gen-key
```

```sh
gpg --list-keys
gpg --list-secret-keys
```

```sh
gpg --import KEYS
```

```sh
gpg --verify cryptopp840.zip.sig
```

```sh
gpg --delete-keys ...
```

### Key servers

```sh
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys DE19B5B4842A97FE
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys DE19B5B4842A97FE
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys DE19B5B4842A97FE
```
