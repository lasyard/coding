# php

```sh
php -v
```

## 8.1.0

### pecl

```sh
pecl list
```

### Install xdebug

```sh
# Homebrew does not mkdir this.
mkdir /usr/local/lib/php/pecl
```

```sh
pecl install xdebug
```

```sh
vi /usr/local/etc/php/8.1/php.ini
```

> ```ini
> [xdebug]
> zend_extension = xdebug.so
> xdebug.mode = debug
> xdebug.start_with_request = true
> ```
