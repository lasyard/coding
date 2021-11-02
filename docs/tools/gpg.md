# gpg

## 2.3.3

```bash
gpg --version
```

```bash
gpg --gen-key
```

```bash
gpg --list-keys
gpg --list-secret-keys
```

```bash
gpg --import KEYS
```

```bash
gpg --verify cryptopp840.zip.sig
```

```bash
gpg --delete-keys ...
```

### Key servers

```bash
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys DE19B5B4842A97FE
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys DE19B5B4842A97FE
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys DE19B5B4842A97FE
```
