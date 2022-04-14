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
# @Desc      :   Test pam_access
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test -f /etc/security/access.conf_pam || mv /etc/security/access.conf  /etc/security/access.conf_pam -f
    echo "-:root:127.0.0.1" >/etc/security/access.conf 
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    SSH_CMD  "echo hello world" 127.0.0.1  xxx root  20 22
    if [ "$?" == "0" ]; then
	varflag=1
    else
    	varflag="0"
    fi
    CHECK_RESULT $varflag 0 0 "failed set access module " 
    LOG_INFO "Start to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/security/access.conf_pam  /etc/security/access.conf -f
    LOG_INFO "End to restore the test environment."
}

main "$@"
