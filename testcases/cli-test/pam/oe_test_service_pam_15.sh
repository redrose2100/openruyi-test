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
# @Date      :   2022/03/23
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_namespace.service restart
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -e /etc/pam.d/sudo-pam && /etc/pam.d/sudo /etc/pam.d/sudo-pam
    echo "auth sufficient pam_rootok.so">/etc/pam.d/sudo
    useradd xtest>/tmp/null 2>&1
    echo xtest:231!#Edcvf| chpasswd  
    useradd xxtest>/tmp/null 2>&1
    echo  xxtest:231!#Edcv| chpasswd  
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    SSH_CMD ${NODE2_IPV4} ${NODE2_PASSWORD} ${NOD2_USER}  20 22
    if [ "$?" == "0" ]; then
    	varflag="1"
    else
	varflag=0
    fi
    CHECK_RESULT $varflag "0"
    LOG_INFO "Finish test!"
}
function post_test(){
    userdel -rf xtest
    userdel -rf xxtest
    mv  /etc/pam.d/sudo-pam /etc/pam.d/sudo
}
main "$@"
