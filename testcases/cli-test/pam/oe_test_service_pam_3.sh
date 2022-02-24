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
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_namespace.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    systemctl stop firewalld 
    ln -sf /usr/sbin/sshd  /tmp/su
    pid_num=`netstat -anp| grep 5555|awk '{print $7}'| awk -F"/" '{print $1}'`;
    kill $pid_num;
    /tmp/su  -oPort=5555
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    SSH_CMD "echo hello;" 127.0.0.1 xxxxx root  20 5555
#    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

#function post_test(){
#pid_num=`netstat -anp| grep 5555|awk '{print $7}'| awk -F"/" '{print $1}'`
#kill $pid_num 
#systemctl restart firewalld
#}
main "$@"
