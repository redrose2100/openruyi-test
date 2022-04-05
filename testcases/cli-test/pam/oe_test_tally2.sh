#!/usr/bin/bash
# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   Wangsongsong
# @Contact   :   1693764552@qq.com
# @Date      :   2022/02/18
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_namespace.service restart
# #############################################
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    systemctl stop firewalld
    ls -sf /usr/sbin/sshd /tmp/su
    /tmp/su -oport=5555
    1、关闭防火墙 systemctl stop firewalld
    2、本端root用户下执行ln -sf /usr/sbin/sshd /tmp/su;/tmp/su -oport=5555
    3、远端执行ssh root@本端IP -p 5555 输入任意密码，有预期结果1

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    3、远端执行ssh root@本端IP -p 5555 输入任意密码，有预期结果1
    CHECK_RESULT 0 0
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    LOG_INFO "End to restore the test environment."
}
main "$@"
