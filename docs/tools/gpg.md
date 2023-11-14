# gpg

## 2.3.3

```sh
gpg --version
```

```sh
gpg --full-generate-key
```

```sh
gpg -k
gpg --list-keys

gpg -K
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

### Export

```sh
gpg --export-secret-keys > secring.gpg

gpg --show-keys secring.gpg
```

### Renew expired keys

```sh
gpg --edit-key <key-fingerprint>
```

> ```gpg
> expire
> save
> ```
