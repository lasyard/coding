# php

## 8.1.0

```sh
php -v
```

For brew installed php on macOS

```sh
export PHP_INI_FILE=/usr/local/etc/php/8.1/php.ini
```

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
vi ${PHP_INI_FILE}
```

> ```ini
> display_errors = On
> display_startup_errors = On
> ```

## 7.4.25

For apt installed php on Debian

```sh
export PHP_INI_FILE=/etc/php/7.4/apache2/php.ini
```
