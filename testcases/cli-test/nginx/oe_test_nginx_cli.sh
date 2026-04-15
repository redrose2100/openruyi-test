#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-10-09
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-nginx
#####################################
# shellcheck disable=SC1090,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nginx gcc openssl"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start nginx
    systemctl status nginx | grep "running"
    CHECK_RESULT $? 0 0 "nginx.service start failed"
    nginx -? 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "nginx -? execution failed"
    nginx -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "nginx -h execution failed"
    test "$(nginx -v 2>&1 | grep -Eo '[0-9]*\.[0-9]*\.[0-9]*')" == \
        "$(rpm -qi nginx | grep 'Version' | awk '{print$3}')"
    CHECK_RESULT $? 0 0 "nginx -v execution failed"
    test "$(nginx -V 2>&1 | grep "version" | grep -Eo "[0-9]*\.[0-9]*\.[0-9]*")" == \
        "$(rpm -qi nginx | grep 'Version' | awk '{print$3}')"
    CHECK_RESULT $? 0 0 "nginx -V failed to check nginx version"
    test "$(nginx -V 2>&1 | grep 'GCC' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[a-z]*' | head -n 1)" == \
        "$(rpm -qi gcc | grep 'Version' | awk '{print$3}')"
    CHECK_RESULT $? 0 0 "nginx -V failed to check gcc version"
    test "$(nginx -V 2>&1 | grep 'OpenSSL' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[a-z]*')" == \
        "$(rpm -qi openssl | grep 'Version' | awk '{print$3}')"
    CHECK_RESULT $? 0 0 "nginx -V failed to check openssl version"
    nginx -t 2>&1 | grep "ok"
    CHECK_RESULT $? 0 0 "nginx -t execution failed"
    nginx -T 2>&1 | grep "successful"
    CHECK_RESULT $? 0 0 "nginx -T execution failed"
    nginx -t -q
    CHECK_RESULT $? 0 0 "nginx -t -q execution failed"
    cp -pv /usr/share/nginx/html/index.html /tmp/oe_test_nginx_cli_index.html.bak
    echo "hello world1" >/usr/share/nginx/html/index.html
    curl localhost 2>&1 | grep "hello"
    CHECK_RESULT $? 0 0 "curl localhost execution failed"
    nginx -s stop
    CHECK_RESULT $? 0 0 "nginx -s stop execution failed"
    SLEEP_WAIT 1
    pgrep nginx
    CHECK_RESULT $? 1
    systemctl start nginx
    SLEEP_WAIT 1
    nginx -s quit
    SLEEP_WAIT 1
    pgrep nginx
    CHECK_RESULT $? 1
    systemctl start nginx
    mv -f /var/log/nginx/access.log /var/log/nginx/access.log.0
    ls /var/log/nginx/access.log
    CHECK_RESULT $? 0 1 "mv -f execution failed"
    nginx -s reopen
    SLEEP_WAIT 1
    ls /var/log/nginx/access.log
    CHECK_RESULT $? 0 0 "nginx -s reopen execution failed"
    cp -pv /etc/nginx/nginx.conf /tmp/oe_test_nginx_cli_nginx.conf.bak
    echo "abc" >>/etc/nginx/nginx.conf
    nginx -s reload
    CHECK_RESULT $? 1
    SLEEP_WAIT 1
    sed -i '/abc/d' /etc/nginx/nginx.conf
    nginx -s reload
    CHECK_RESULT $? 0 0 "nginx -s reload execution failed"
    nginx -s quit
    cp /etc/nginx/nginx.conf /root/ -rf
    sed -i 's/80/81/g' /root/nginx.conf
    SLEEP_WAIT 1
    nginx -c /root/nginx.conf
    CHECK_RESULT $? 0 0 "nginx -c execution failed"
    echo "hello world2" >/usr/share/nginx/html/index.html
    curl localhost:81 2>&1 | grep "hello"
    CHECK_RESULT $? 0 0 " execution failed"
    nginx -p /root/
    SLEEP_WAIT 1
    test "$(pgrep -f nginx -a | grep -c master)" -eq 2
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 nginx
    rm -rf /root/nginx.conf /tmp/oe_test_nginx_cli_*
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
