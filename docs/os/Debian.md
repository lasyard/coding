# Debian

## 11 (bullseye)

```sh
cat /etc/debian_version
```

### grub

```sh
sudo vi /etc/default/grub
```

> ```properties
> GRUB_TIMEOUT=1
> ```

```sh
sudo update-grub
```

### sudo

Run as root

```sh
/sbin/adduser xxx sudo
```

### Install packages

```sh
sudo apt satisfy linux-headers-$(uname -r) build-essential
```

```sh
sudo apt satisfy curl
```

```sh
sudo apt satisfy apache2 php php-dev php-pear php-mysql php-mbstring
```

```sh
sudo apt satisfy cmake
```

```sh
sudo apt satisfy libcrypto++-dev libwxgtk3.0-gtk3-dev
```

### systemctl

```sh
systemctl get-default
systemctl list-units --type=target
sudo systemctl edit --full apache2.service
```
