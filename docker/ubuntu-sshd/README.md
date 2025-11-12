# ubuntu-sshd

## Build

```console
$ docker build -t ubuntu-sshd:22.04 .
```

## Run

```console
$ docker run --rm -d -p 10022:22 -v /home/ubuntu/.ssh/authorized_keys:/home/ubuntu/.ssh/authorized_keys ubuntu-sshd:22.04 
```

Connect to it:

```console
$ ssh -p 10022 localhost
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-151-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
...
```

Our host and container use the same user name and id (`ubuntu(1000)`), so it is authorized smoothly. Note the files seen in the container has the same ownership and permission as their mappings in the host.
