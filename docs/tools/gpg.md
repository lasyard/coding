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
gpg --import <key-file>
```

```sh
gpg --verify *.sig
```

```sh
gpg --delete-keys <key-fingerprint>
```

### Key servers

```sh
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys <key-fingerprint>
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys <key-fingerprint>
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys <key-fingerprint>
```
