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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @modify    :   wangxiaoya@qq.com
# @Date      :   2022/05/12
# @License   :   Mulan PSL v2
# @Desc      :   View SELinux logs in audit
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "audit httpd libselinux"
    setenforce 1  #如果在内核层禁用了selinux,那么这里是无法打开的
    if [ "$(getenforce)" == "Disabled" ]; then
        LOG_WARN "Testing cannot be performed if selinux cannot be enabled."
        exit 255
    fi
    systemctl start auditd
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    sed -i 's|Listen 80|Listen 1924|' /etc/httpd/conf/httpd.conf
    systemctl restart httpd
    CHECK_RESULT $? 1 0
    ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR > selinux_log
    CHECK_RESULT $?
    test "$(grep -c AVC selinux_log)" -gt 0
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cp /etc/httpd/conf/httpd.conf.bak /etc/httpd/conf/httpd.conf
    rm -rf selinux_log
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
