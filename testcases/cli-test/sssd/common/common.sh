#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wenjun
# @Contact   :   1009065695@qq.com
# @Date      :   2023.09.21
# @License   :   Mulan PSL v2
# @Desc      :   sssd prepare
# ############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function openldap_server_pre() {
    old_hostname=$(hostname)
    cat > server.sh << !
systemctl stop firewalld
systemctl disable firewalld
dnf install -y openldap-servers openldap-clients openssl expect
hostnamectl set-hostname ldap.huawei.com
cp /etc/hosts /etc/hosts_bak
echo "${NODE2_IPV4} ldap.huawei.com" >> /etc/hosts
cd /etc/openldap/certs/
openssl genrsa -out rootCA.key 4096

expect <<EOF
spawn openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem
expect "Country Name*" {send "\n"}
expect "State or Province Name*" {send "\n"}
expect "Locality Name*" {send "\n"}
expect "Organization Name*" {send "\n"}
expect "Organizational Unit Name*" {send "\n"}
expect "Common Name*" {send "CACenter\n"}
expect "Email Address*" {send "\n"}
expect "" {send "quit\n"}
expect eof
EOF

openssl genrsa -out ldapserver.key 4096

expect <<EOF
spawn openssl req -new -key ldapserver.key -out ldapserver.csr
expect "Country Name*" {send "\n"}
expect "State or Province Name*" {send "\n"}
expect "Locality Name*" {send "\n"}
expect "Organization Name*" {send "\n"}
expect "Organizational Unit Name*" {send "\n"}
expect "Common Name*" {send "ldap.huawei.com\n"}
expect "Email Address*" {send "\n"}
expect "*password*" {send "\n"}
expect "*company name*" {send "\n"}
expect "" {send "quit\n"}
expect eof
EOF

openssl x509 -req -in ldapserver.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out ldapserver.csr -days 1460 -sha256
chown -R ldap:ldap /etc/openldap/certs
cp /usr/share/openldap-servers/slapd.ldif /etc/openldap/
password=\$(slappasswd -s "${NODE2_PASSWORD}")
sed -i '/olcRootDN/a\olcRootPW: '"\${password}" /etc/openldap/slapd.ldif
sed -i '/dn: cn=config/a\olcTLSCACertificateFile: /etc/openldap/certs/rootCA.pem\nolcTLSCertificateFile: /etc/openldap/certs/ldapserver.csr\nolcTLSCertificateKeyFile: /etc/openldap/certs/ldapserver.key' /etc/openldap/slapd.ldif

rm -rf /etc/openldap/slapd.d/*
slapadd -F /etc/openldap/slapd.d -n 0 -l /etc/openldap/slapd.ldif
chown -R ldap:ldap /etc/openldap/slapd.d/
slaptest -u -F /etc/openldap/slapd.d/

systemctl restart slapd
systemctl enable slapd

ldapadd -Y EXTERNAL -H LDAPI:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H LDAPI:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H LDAPI:/// -f /etc/openldap/schema/inetorgperson.ldif

echo "dn: dc=my-domain,dc=com
dc: my-domain
objectClass: top
objectClass: domain

dn: cn=Manager,dc=my-domain,dc=com
objectClass: organizationalRole
cn: Manager


dn: ou=People,dc=my-domain,dc=com
ou: People
objectClass: top
objectClass: organizationalUnit


dn: ou=Group,dc=my-domain,dc=com
ou: Group
objectClass: top
objectClass: organizationalUnit
" > /etc/openldap/base.ldif

echo "dn: cn=group1,ou=Group,dc=my-domain,dc=com
objectClass: posixGroup
objectClass: top
cn: group1
gidNumber: 1001


dn: cn=group2,ou=Group,dc=my-domain,dc=com
objectClass: posixGroup
objectClass: top
cn: group2
gidNumber: 1002
" > /etc/openldap/group.ldif

echo "dn: uid=user1,ou=People,dc=my-domain,dc=com
uid: user1
cn: user1
objectClass: account
objectClass: posixAccount
objectClass: top
objectClass: shadowAccount
userPassword: {crypt}*
shadowMax: 99999
shadowWarning: 7
loginShell: /bin/bash
uidNumber: 1001
gidNumber: 1001
homeDirectory: /home/user1

dn: uid=user2,ou=People,dc=my-domain,dc=com
uid: user2
cn: user2
objectClass: account
objectClass: posixAccount
objectClass: top
objectClass: shadowAccount
userPassword: {crypt}*
shadowMax: 99999
shadowWarning: 7
loginShell: /bin/bash
uidNumber: 1002
gidNumber: 1002
homeDirectory: /home/user2
" > /etc/openldap/user.ldif

ldapadd -D "cn=Manager,dc=my-domain,dc=com" -x -f /etc/openldap/base.ldif -H ldapi:/// -w "${NODE2_PASSWORD}"
ldapadd -D "cn=Manager,dc=my-domain,dc=com" -x -f /etc/openldap/group.ldif -H ldapi:/// -w "${NODE2_PASSWORD}"
ldapadd -D "cn=Manager,dc=my-domain,dc=com" -x -f /etc/openldap/user.ldif -H ldapi:/// -w "${NODE2_PASSWORD}"

ldappasswd -x -D 'cn=Manager,dc=my-domain,dc=com' -w "${NODE2_PASSWORD}" -H ldapi:/// "uid=user1,ou=People,dc=my-domain,dc=com" -s "${NODE2_PASSWORD}"
ldappasswd -x -D 'cn=Manager,dc=my-domain,dc=com' -w "${NODE2_PASSWORD}" -H ldapi:/// "uid=user2,ou=People,dc=my-domain,dc=com" -s "${NODE2_PASSWORD}"

systemctl restart slapd

#search
ldapsearch -H ldapi:/// -b "dc=my-domain,dc=com" -D "cn=Manager,dc=my-domain,dc=com" -w "${NODE2_PASSWORD}"
!
    SSH_SCP server.sh "${NODE2_USER}"@"${NODE2_IPV4}":/root "${NODE2_PASSWORD}"
    P_SSH_CMD --node 2 --cmd "sh /root/server.sh"
    rm -rf server.sh
}

function openldap_server_post() {
    P_SSH_CMD --node 2 --cmd "
    systemctl stop slapd
    systemctl start firewalld
    systemctl enable firewalld
    hostnamectl set-hostname '${old_hostname}'
    mv -f /etc/hosts_bak /etc/hosts
    rm -rf /root/server.sh
    dnf remove -y openldap-servers openldap-clients openssl expect"
}

function openldap_client_pre() {
    DNF_INSTALL "openldap-clients sssd"
    old_hostname=$(hostname)
    hostnamectl set-hostname openldap.client
    cp /etc/hosts /etc/hosts_bak
    echo "${NODE2_IPV4} ldap.huawei.com" >> /etc/hosts
    echo "BASE dc=my-domain,dc=com
URI ldap://ldap.huawei.com
TLS_CACERT never
" >> /etc/openldap/ldap.conf
    ldapsearch -H ldap://ldap.huawei.com -b "dc=my-domain,dc=com" -D "cn=Manager,dc=my-domain,dc=com" -w "${NODE1_PASSWORD}"

    echo "auth        sufficient    pam_sss.so use_first_pass
account     [default=bad success=ok user_unknown=ignore] pam_sss.so
password    sufficient    pam_sss.so use_authtok
session     optional      pam_sss.so
session optional pam_mkhomedir.so umask=0077
" >> /etc/pam.d/password-auth
    cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf_bak
    echo "[sssd]
services = nss, pam
domains = LDAP
debug_level = 6

[domain/LDAP]
id_provider = ldap
auth_provider = ldap
chpass_provider = ldap
autofs_provider = ldap
ldap_schema = rfc2307bis
ldap_id_use_start_tls = false
ldap_tls_reqcert = never
enumerate = True
cache_credentials = True
ldap_uri = ldap://ldap.huawei.com:389
ldap_search_base = dc=my-domain,dc=com
timeot = 30
debug_level = 6

[nss]
homedir_substring = /home
enum_cache_timeout = 10
debug_level = 6

[pam]
offline_credentials_expiration = 1
debug_level = 6
" > /etc/sssd/sssd.conf

systemctl restart sssd
}

function openldap_client_post() {
    systemctl stop sssd
    mv /etc/sssd/sssd.conf_bak /etc/sssd/sssd.conf
    hostnamectl set-hostname "${old_hostname}"
    mv -f /etc/hosts_bak /etc/hosts
    DNF_REMOVE "$@"
}
