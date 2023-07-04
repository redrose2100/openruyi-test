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
# @Desc      :   Test pam_namespace.service restart
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -f /etc/pam.d/passwd_bak||mv /etc/pam.d/passwd  /etc/pam.d/passwd_bak -f
    echo "password requisite  pam_cracklib.so try_first_pass retry=3 dcredit=-5 ocredit=-3" >>/etc/pam.d/passwd
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    useradd xtest>/tmp/null 2>&1
    echo xtest:123| chpasswd  
    if [ "$?" == "0" ]; then
    	varflag="1"
    else
	varflag="0"
    fi
    CHECK_RESULT $varflag "0" "0" "failed to set password"
    LOG_INFO "Finish test!"
}

function post_test(){
    mv /etc/pam.d/passwd_bak  /etc/pam.d/passwd -f 
}
main "$@"
