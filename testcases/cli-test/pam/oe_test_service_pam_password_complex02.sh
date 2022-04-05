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
# @Desc      :   Test password_complex02 
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -e /etc/pam.d/password-auth_bak || mv /etc/pam.d/password-auth /etc/pam.d/password-auth_bak
    test -e /etc/pam.d/system-auth_bak   || mv /etc/pam.d/system-auth /etc/pam.d/system-auth_bak 
    echo "password    requisite     pam_pwquality.so  enforce_for_root try_first_pass local_users_only retry=3 dcredit=0 ucredit=0 lcredit=0 ocredit=0">/etc/pam.d/password-auth
    echo "password    required      pam_pwhistory.so use_authtok enforce_for_root">>/etc/pam.d/password-auth
    echo "password    requisite     pam_pwquality.so enforce_for_root try_first_pass local_users_only retry=3 dcredit=0 ucredit=0 lcredit=0 ocredit=0">/etc/pam.d/system-auth
    echo "password    required      pam_pwhistory.so use_authtok  enforce_for_root">>/etc/pam.d/system-auth
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    if id -u test_01x >/dev/null 2>&1; then  
        echo "test_xx10 exists"               
    else                                   
        useradd test_x10>/tmp/null 2>&1       
    fi                                         
    echo    test_xx10:01xx_tset| chpasswd  
    if [ "$?" == "0" ]; then
	varflag=0
    else
    	varflag="1"
    fi
    CHECK_RESULT $varflag "1" "0"  "failed to set /etc/pam.d/password-auth /etc/pam.d/system-auth"
    LOG_INFO "Finish test!"
}
function post_test(){
    userdel -rf test_xx10
    mv /etc/pam.d/password-auth_bak /etc/pam.d/password-auth
    mv /etc/pam.d/system-auth_bak /etc/pam.d/system-auth
}
main "$@"
