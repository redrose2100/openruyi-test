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
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_namespace.service restart
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -e /etc/pam.d/sshd_bak || mv /etc/pam.d/sshd   /etc/pam.d/sshd_bak -f
    test -e /etc/pam.d/login_bak || mv /etc/pam.d/login /etc/pam.d/login_bak -f
    test -e /etc/pam.d/deniedusers_bak || mv /etc/ssh/deniedusers /etc/ssh/deniedusers_bak -f
    echo "auth required pam_listfile.so onerr=succeed item=user sense=deny file=/etc/ssh/deniedusers" > /etc/pam.d/sshd 
    echo "auth required pam_listfile.so onerr=succeed item=user sense=deny file=/etc/ssh/deniedusers" > /etc/pam.d/login 
    echo ${NODE1_USER} > /etc/ssh/deniedusers 
    chmod 600 /etc/ssh/deniedusers 

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    SSH_CMD "echo hello;" ${NODE2_IPV4} ${NODE2_PASSWORD}  ${NODE2_USER}  20 22
    if [ "$?" == "0" ]; then
    	varflag="0"
    else
	varflag=1
    fi
    CHECK_RESULT $varflag "0"
    LOG_INFO "Finish test!"
}

function post_test(){
     mv /etc/pam.d/sshd_bak  /etc/pam.d/sshd -f
     mv /etc/pam.d/login_bak  /etc/pam.d/login -f
     mv /etc/ssh/deniedusers_bak  /etc/ssh/deniedusers -f
}
main "$@"
