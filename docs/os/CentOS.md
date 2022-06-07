# CentOS

## 7.6

### EPEL

```sh
yum install epel-release
```

### SELinux

```sh
getenforce
```

Temporarily disable it

```sh
setenforce 0
```

```sh
vi /etc/selinux/config
```

> ```txt
> SELINUX=disabled
> ```

### Set hostname

```sh
vi /etc/hosts
vi /etc/hostname
```

```sh
hostname
hostname -F /etc/hostname
```

### systemctl

```sh
systemctl status
systemctl stop firewalld
systemctl disable firewalld
```

### time zone

```sh
timedatectl
timedatectl list-timezones
timedatectl set-timezone Asia/Shanghai
timedatectl set-timezone Europe/London
```
