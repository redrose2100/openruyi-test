#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/11/29
# @License   :   Mulan PSL v2
# @Desc      :   SSL protocol encrypted transmission service
# #############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "openssl expect httpd mod_ssl"
    firewall-cmd --state|grep "not running"
    firewalld_status=$?
    systemctl stop firewalld

    mkdir -p /www/https
    mv -f /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.bak
    echo "This is https test" > /www/https/index.html
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl genrsa -aes128 -passout pass:openEuler12#$ 2048 > /etc/httpd/conf.d/1.key
    test -f /etc/httpd/conf.d/1.key
    CHECK_RESULT $? 0 0 "1.key generation failed"
    openssl req -utf8 -new -x509 -key /etc/httpd/conf.d/1.key -out /etc/httpd/conf.d/1.crt -passin pass:openEuler12#$ -subj "/C=CN/ST=Beijing/L=Beijing/O=oerv/CN=domain.com/emailAddress=name@example.com"
    test -f /etc/httpd/conf.d/1.crt
    CHECK_RESULT $? 0 0 "1.crt generation failed"

    cat >/etc/httpd/conf.d/host.conf <<EOF
SSLPassPhraseDialog exec:/usr/libexec/httpd-ssl-pass-dialog
listen 4443
<VirtualHost localhost>
    SSLEngine on
    SSLCertificateFile /etc/httpd/conf.d/1.crt
    SSLCertificateKeyFile /etc/httpd/conf.d/1.key
    DocumentRoot /www/https
    ServerName localhost
</VirtualHost>
<Directory /www/https>
    AllowOverride None
    Require all granted
</Directory>
EOF
    CHECK_RESULT $? 0 0 "host.conf generation failed"

    cat > http.sh <<EOF
#!/usr/bin/expect -f
spawn systemctl restart httpd
expect -re "Enter TLS private key passphrase.*:"
send "openEuler12#$\\r"
expect eof
EOF
    expect http.sh
    CHECK_RESULT $? 0 0 "Script execution failed."
    wget https://localhost:4443 --no-check-certificate && grep "This is https test" index.html
    CHECK_RESULT $? 0 0 "wget Access failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /www http.sh /etc/httpd/conf.d/host.conf /etc/httpd/conf.d/1.key /etc/httpd/conf.d/1.crt ./index.html
    mv -f /etc/httpd/conf.d/ssl.conf.bak /etc/httpd/conf.d/ssl.conf
    systemctl stop httpd
    DNF_REMOVE "$@"
    if [ ${firewalld_status} -eq 1 ];then
        systemctl start firewalld
    fi
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
