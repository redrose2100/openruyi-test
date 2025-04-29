#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   chenzirui
# @Contact   :   ziruichen@126.com
# @Date      :   2022/10/01
# @License   :   Mulan PSL v2
# @Desc      :   Test wsmancli
# #############################################
# shellcheck disable=SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli openwsman-server python3-passlib"
    echo '#!/usr/bin/env python3
import argparse
import random
import string
from passlib.hash import sha512_crypt, md5_crypt, des_crypt

def generate_password(password, salt="aN"):
    """生成加密密码"""
    return des_crypt.using(salt=salt).hash(password)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="生成加密密码工具")
    parser.add_argument("-p", "--password", required=True, help="明文密码")
    parser.add_argument("-s", "--salt", default="aN", help="盐值")
    args = parser.parse_args()

    try:
        encrypted = generate_password(args.password, args.salt)
        print(f"wsman:{encrypted}")
    except Exception as e:
        print(f"错误: {e}")' >crypt_test.py
    chmod 777 crypt_test.py
    ./crypt_test.py -p "wsman" >/etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-q,--non-interactive,-d,-j,-c,-A,-K,-u,-J]
    # test option: -q
    wsman -q | grep wsmancli
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -q"
    # test option: --non-interactive if not --non-interactive you should retype correct username and password
    wsman identify -h localhost --port 5985 -u wsman --password wsmanerr --non-interactive 2>&1 | grep "Login denied"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --non-interactive"
    # test option: -d
    wsman identify -h localhost --port 5985 -u wsman --password wsman -d 1 | grep "HTTP"
    CHECK_RESULT $? 1 0 "wamancli: faild to test option -d"
    # level 4 generate detail log
    wsman identify -h localhost --port 5985 -u wsman --password wsman -d 4 2>&1 | grep "HTTP"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -d"
    # test option: -j
    wsman identify -h localhost --port 5985 -u wsman --password wsman -j GBK | grep '<?xml version="1.0" encoding="GBK"?>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -j"
    # test option: -J
    wsman identify -h localhost --port 5985 -u wsman --password wsman -J my.cert
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -J"
    # test option: -c
    kill -9 $(pgrep -f "openwsmand -c")
    expect <<EOF
        spawn /etc/openwsman/owsmangencert.sh --force
        expect {
            "Country Name" { send "CN\\r"; exp_continue }
            "State or Province Name" { send "jiangsu\\r"; exp_continue }
            "Locality Name" { send "nanjing\\r"; exp_continue }
            "Organization Name" { send "company\\r"; exp_continue }
            "Organizational Unit Name" { send "section\\r"; exp_continue }
            "server name" { send "localhost\\r"; exp_continue }
            "Email Address" { send "test@test.com\\r"; exp_continue }
        }
        expect eof
EOF
    useradd wsman
    printf 'wsman\nwsman\n' | passwd wsman
    systemctl start openwsmand
    SLEEP_WAIT 3
    wsman identify -h localhost --port 5986 -u wsman --password wsman -c /etc/openwsman/servercert.pem -d 6 2>&1 | grep -i "ssl certificate verify ok"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -c"
    # test option: -K
    wsman identify -h localhost --port 5986 -u wsman --password wsman -c /etc/openwsman/servercert.pem -K /etc/openwsman/servercert.pem -d 6 2>&1 | grep "200 OK"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -K"
    # test option: -A
    openssl genrsa -out client.key 2048
    openssl req -new -key client.key -out client.csr -subj "/CN=client.example.com"
    openssl x509 -req -in client.csr -signkey client.key -out client.crt -days 365
    cat client.key client.crt >/etc/openwsman/clientcert.pem
    chmod 600 /etc/openwsman/clientcert.pem
    wsman identify -h localhost --port 5986 -u wsman --password wsman -c /etc/openwsman/servercert.pem -A /etc/openwsman/clientcert.pem -d 6 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -A"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd /etc/openwsman/*.pem ./client* ./crypt_test.py
    uerdel -rf wsman
    kill -9 $(pgrep openwsmand)
    DNF_REMOVE "$@"
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
