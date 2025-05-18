# Based on https://github.com/trfore/docker-centos9-systemd
FROM quay.io/centos/centos:stream9 AS base

ENV container=docker

ARG username

RUN dnf update
RUN dnf -y install \
    epel-release \
    hostname \
    initscripts \
    iproute \
    openssl \
    openssh \
    openssh-server \
    sudo \
    which

RUN rm -Rf /usr/share/doc && rm -Rf /usr/share/man && dnf clean all

# hotfix for issue #49
RUN chmod 0400 /etc/shadow

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]

RUN adduser ${username}
RUN echo ${username}:password | chpasswd
RUN usermod -aG wheel ${username}

RUN ssh-keygen -A

USER ${username}

RUN mkdir ~/.ssh
RUN touch ~/.ssh/authorized_keys
RUN chmod 700 ~/.ssh
RUN chmod 600 ~/.ssh/authorized_keys

COPY ssh_host_rsa_key.pub rsa_key.pub
RUN cat rsa_key.pub >> ~/.ssh/authorized_keys

USER root

EXPOSE 22

RUN systemctl enable sshd
CMD ["/sbin/init"]

FROM base AS authserver

RUN dnf -y install openldap-servers openldap-clients

COPY authserver home/${username}/

EXPOSE 389

FROM base AS client

RUN dnf -y install openldap-clients nss-pam-ldapd sssd-ldap authselect oddjob-mkhomedir

RUN systemctl enable oddjobd

COPY client home/${username}/