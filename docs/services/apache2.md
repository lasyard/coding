# apache2

## 2.4.51 (Debian 11)

### Restart

```sh
systemctl restart apache2
```

### User and group

```sh
sudo vi /etc/apache2/envvars
```

> ```sh
> export APACHE_RUN_USER=www-data
> export APACHE_RUN_GROUP=www-data
> ```

### Config

```sh
sudo vi /etc/apache2/apache2.conf
```

### Enable module

```sh
sudo a2enmod rewrite
```

### Site

```sh
sudo vi /etc/apache2/sites-enabled/000-default.conf
```

> ```apache
> <VirtualHost *:80>
>    DocumentRoot /www/root
>    <Directory "/www/root">
>        Options Indexes FollowSymLinks
>        AllowOverride All
>        Require all granted
>    </Directory>
> </VirtualHost>
> ```

## 2.4.51 (macOS Monterey)

```sh
httpd -v
```

### Enable php

You need install php mannually for php is depracated in this version.

Sign the php lib

```sh
codesign --sign 'XXX' --force --keychain ~/Library/Keychains/login.keychain-db /usr/local/opt/php/lib/httpd/modules/libphp.so
codesign -dv --verbose=4 /usr/local/opt/php/lib/httpd/modules/libphp.so
```

See the line begin with `Authority=`, the value may be `XXX's CA`.

```sh
sudo vi /etc/apache2/httpd.conf
```

> ```apache
> LoadModule php_module /usr/local/opt/php/lib/httpd/modules/libphp.so "XXX's CA"
> ```

```sh
sudo vi /etc/apache2/other/php.conf
```

> ```apache
> <IfModule php_module>
>     AddType application/x-httpd-php .php
>     AddType application/x-httpd-php-source .phps
>
>     <IfModule dir_module>
>         DirectoryIndex index.html index.php
>     </IfModule>
> </IfModule>
> ```

```sh
apachectl configtest
```

## 2.4.48 (macOS Big Sur)

### Start, stop & restart

```sh
sudo apachectl start
sudo apachectl stop
sudo apachectl restart
```

### Error log

```sh
tail -f /var/log/apache2/error_log
```

### Enable server status & info

```sh
sudo vi /etc/apache2/httpd.conf
```

> ```apache
> ServerName localhost:80
>
> LoadModule status_module libexec/apache2/mod_status.so
> LoadModule info_module libexec/apache2/mod_info.so
>
> Include /private/etc/apache2/extra/httpd-info.conf
> ```

```sh
sudo vi /etc/apache2/extra/httpd-info.conf
```

> ```apache
> <Location /server-status>
>     SetHandler server-status
>     Require host localhost
>     Require ip 127
> </Location>
> <Location /server-info>
>     SetHandler server-info
>     Require host localhost
>     Require ip 127
> </Location>
>```

View the sites

```sh
curl http://localhost/server-status
curl http://localhost/server-info
```

### Enable user dir & php

```sh
mkdir Sites
```

```sh
sudo vi /etc/apache2/httpd.conf
```

> ```apache
> LoadModule php7_module libexec/apache2/libphp7.so
> LoadModule rewrite_module libexec/apache2/mod_rewrite.so
> LoadModule userdir_module libexec/apache2/mod_userdir.so
>
> Include /private/etc/apache2/extra/httpd-userdir.conf
> ```

```sh
sudo vi /etc/apache2/extra/httpd-userdir.conf
```

> ```apache
> UserDir Sites
> Include /private/etc/apache2/users/*.conf
> ```

Remove guest

```sh
sudo rm /etc/apache2/users/Guest.conf
```

Create user `xxx`

```sh
sudo vi /etc/apache2/users/xxx.conf
```

> ```apache
> <Directory "/Users/xxx/Sites">
>     Options Indexes FollowSymLinks
>     AllowOverride All
>     Require host localhost
>     Require ip 127
> </Directory>
> ```
