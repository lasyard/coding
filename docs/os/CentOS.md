# CentOS

## 8.3

```sh
cat /etc/centos-release
```

### Change repo url

```sh
sed -i -e "s|mirrorlist=|#mirrorlist=|" /etc/yum.repos.d/CentOS-Linux-*.repo
sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|" /etc/yum.repos.d/CentOS-Linux-*.repo
```

### dnf

```sh
dnf list installed
dnf repoquery -l <package-name>
```

### Install development tools

```sh
dnf install gcc-toolset-11
dnf install autoconf
dnf install automake
dnf install libtool
dnf install clang-tools-extra # clang-format, clang-tidy, etc.
```

```sh
dnf install openssl-devel
```

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

### Install development tools

```sh
yum groupinstall "Development Tools"
```

```sh
yum install centos-release-scl
yum install devtoolset-11
scl enable devtoolset-11 bash
```

The last command will open a new shell in which the new toolset enabled, or put the following in `.bash_profile`

```sh
source /opt/rh/devtoolset-11/enable
```
