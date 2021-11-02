# apache2

## 2.4.48 (macOS Big Sur)

```sh
httpd -v
```

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
