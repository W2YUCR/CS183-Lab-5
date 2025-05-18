#!/bin/bash
authselect select sssd with-mkhomedir --force
mkdir -p /etc/sssd
cp sssd.conf /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf
systemctl restart sssd
systemctl restart oddjobd