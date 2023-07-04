#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/23
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_env
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {  
    cmd="test -e /tmp/a && rm -rf /tmp/a; \
    mv /etc/security/pam_env.conf /etc/security/pam_env.conf_bak -f; \
    echo HOME DEFAULT=\${HOME} OVERRIDE=/var/>/etc/security/pam_env.conf"
    SSH_CMD "$cmd" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 20 22    
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    touch \$HOME>/tmp/a
    chmod 777 \$HOME>/tmp/a
    SSH_CMD "echo \$HOME>/tmp/a" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 20 22
    CHECK_RESULT $? 0 0 "failed to login NODE2_USER"
    SSH_SCP root@${NODE2_IPV4}:/tmp/a /tmp/a ${NODE2_PASSWORD} 
    CHECK_RESULT $? 0 0 "failed to send /tmp/a"
    grep "/var/" /tmp/a
    CHECK_RESULT $? 0 0 "failed to find /var/"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/*
    mv /etc/security/pam_env.conf_bak /etc/security/pam_env.conf -f
    LOG_INFO "End to restore the test environment."
}
main "$@"
