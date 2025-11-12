ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}
LABEL authors="Yueguang Jiao"
LABEL description="Ubuntu with opernssh-server intalled"

RUN apt-get update \
    && apt-get install -y openssh-server --no-install-recommends \
    && mkdir /var/run/sshd

ARG SSH_PORT=22

EXPOSE ${SSH_PORT}

ARG USER=ubuntu

# create user
RUN useradd -c "User" -u1000 ${USER} -s/bin/bash

VOLUME [ "/home/${USER}/.ssh/authorized_keys" ]

# clean
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/sbin/sshd", "-D", "-e"]
