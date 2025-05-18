#!/bin/bash
systemctl enable --now slapd

read -s -p "Enter new LDAP password: " ldap_password

hashed_password=$(slappasswd -h {SSHA} -s "${ldap_password}")

sed -i "s/HASHED_PASSWORD/${hashed_password}/g" chrootpw.ldif

ldapmodify -Y EXTERNAL  -H ldapi:/// -f chdomain.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

ldapadd -x -H ldapi:/// -D "cn=ldapadm,dc=cs183,dc=local" -f base.ldif -w ${ldap_password}
ldapadd -x -H ldapi:/// -D "cn=ldapadm,dc=cs183,dc=local" -f allan-ldap.ldif -w ${ldap_password}

read -s -p "Enter new password for Allan: " password
ldappasswd -s "${password}" -D "cn=ldapadm,dc=cs183,dc=local" -x "uid=allan-ldap,ou=People,dc=cs183,dc=local" -w ${ldap_password}
