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
    DNF_INSTALL "openssl httpd mod_ssl"
    systemctl stop firewalld
    mkdir -p /www/https
    mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.bak
    echo "This is https test" >/www/https/index.html
    Default_Lang=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl genrsa -aes128 -passout pass:deepin12#$ 2048 >/etc/httpd/conf.d/1.key
    test -f /etc/httpd/conf.d/1.key
    CHECK_RESULT $? 0 0 "File generation failed"
    openssl req -utf8 -new -x509 -key /etc/httpd/conf.d/1.key -out /etc/httpd/conf.d/1.crt -passin pass:deepin12#$ -subj "/C=/ST=/L=/O=/CN=/emailAddress="
    test -f /etc/httpd/conf.d/1.crt
    CHECK_RESULT $? 0 0 "File generation failed"
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
    CHECK_RESULT $? 0 0 "File generation failed"
    cat >http.sh <<EOF
#!/usr/bin/expect -f
spawn systemctl restart httpd
expect -re "Enter TLS private key passphrase.*:"
send "deepin12#$\\r"
expect eof
EOF
    expect http.sh
    CHECK_RESULT $? 0 0 "Script execution failed"
    SLEEP_WAIT 3
    curl --insecure https://localhost:4443 | grep -i "This is https test"
    CHECK_RESULT $? 0 0 "Access failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /www http.sh /etc/httpd/conf.d/host.conf /etc/httpd/conf.d/1.key /etc/httpd/conf.d/1.crt
    mv -f /etc/httpd/conf.d/ssl.conf.bak /etc/httpd/conf.d/ssl.conf
    systemctl stop httpd
    systemctl start firewalld
    DNF_REMOVE "$@"
    export LANG=$Default_Lang
    LOG_INFO "End to restore the test environment."
}

main "$@"
