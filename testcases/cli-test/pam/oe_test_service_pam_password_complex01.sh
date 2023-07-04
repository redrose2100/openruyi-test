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
    test -f /etc/pam.d/password-auth_bak || mv /etc/pam.d/password-auth /etc/pam.d/password-auth_bak -f
    test -f /etc/pam.d/system-auth_bak   || mv /etc/pam.d/system-auth /etc/pam.d/system-auth_bak -f
    echo "password    requisite     pam_pwquality.so minlen=8 minclass=3 enforce_for_root try_first_pass local_users_only dcredit=0 ucredit=0 lcredit=0 ocredit=0">/etc/pam.d/password-auth
    echo "password    required      pam_pwhistory.so use_authtok remember=5 enforce_for_root">>/etc/pam.d/password-auth
    echo "password    requisite     pam_pwquality.so minlen=8 minclass=3 enforce_for_root try_first_pass local_users_only  dcredit=0 ucredit=0 lcredit=0 ocredit=0">/etc/pam.d/system-auth
    echo "password    required      pam_pwhistory.so use_authtok remember=5 enforce_for_root">>/etc/pam.d/system-auth
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    if id -u xxtest >/dev/null 2>&1; then  
        echo "xxtest exists"               
    else                                   
        useradd xxtest>/tmp/null 2>&1       
    fi    
    passwd -d xxtest
    echo xxtest:123| chpasswd  
    if [ "$?" == "0" ]; then
	varflag1=1
    else
    	varflag1="0"
    fi
    echo "a1"
    passwd -d xxtest
    echo xxtest:12^Edcvf| chpasswd  
    echo "a3"
    if [ "$?" == "0" ]; then
	varflag2=1
    else
    	varflag2="0"
    fi
    echo "a2"
    varflag=${varflag2}${varflag1}  
    CHECK_RESULT $varflag "10" "0"  "failed to set /etc/pam.d/password-auth /etc/pam.d/system-auth"
    LOG_INFO "Finish test!"
}
function post_test(){
    mv /etc/pam.d/password-auth_bak /etc/pam.d/password-auth -f
    mv /etc/pam.d/system-auth_bak /etc/pam.d/system-auth -f
    userdel -rf xxtest 
}
main "$@"
