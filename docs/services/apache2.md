# apache2

## 2.4.48 (macOS Big Sur)

```bash
httpd -v
```

### Start, stop & restart

```bash
sudo apachectl start
sudo apachectl stop
sudo apachectl restart
```

### Error log

```bash
tail -f /var/log/apache2/error_log
```

### Enable server status & info

```bash
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

```bash
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

```bash
curl http://localhost/server-status
curl http://localhost/server-info
```

### Enable user dir & php

```bash
mkdir Sites
```

```bash
sudo vi /etc/apache2/httpd.conf
```

> ```apache
> LoadModule php7_module libexec/apache2/libphp7.so
> LoadModule rewrite_module libexec/apache2/mod_rewrite.so
> LoadModule userdir_module libexec/apache2/mod_userdir.so
>
> Include /private/etc/apache2/extra/httpd-userdir.conf
> ```

```bash
sudo vi /etc/apache2/extra/httpd-userdir.conf
```

> ```apache
> UserDir Sites
> Include /private/etc/apache2/users/*.conf
> ```

Remove guest

```bash
sudo rm /etc/apache2/users/Guest.conf
```

Create user `xxx`

```bash
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
