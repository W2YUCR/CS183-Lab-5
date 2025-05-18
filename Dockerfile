# Based on https://github.com/trfore/docker-centos9-systemd
FROM quay.io/centos/centos:stream9 AS base

ENV container=docker

RUN dnf update
RUN dnf -y install \
    epel-release \
    hostname \
    initscripts \
    iproute \
    openssl \
    sudo \
    which

RUN rm -Rf /usr/share/doc && rm -Rf /usr/share/man && dnf clean all

# selectively remove systemd targets -- See https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# hotfix for issue #49
RUN chmod 0400 /etc/shadow

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]

FROM base AS authserver

RUN dnf -y install openldap-servers openldap-clients

COPY authserver .

EXPOSE 389

FROM base AS client

RUN dnf -y install openldap-clients nss-pam-ldapd sssd-ldap authselect

COPY client .