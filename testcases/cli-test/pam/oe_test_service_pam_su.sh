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
# @Date      :   2022/03/15
# @License   :   Mulan PSL v2
# @Desc      :   Test su
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    test -e /etc/pam.d/su_bak || mv  /etc/pam.d/su /etc/pam.d/su_bak -f
    echo "auth sufficient pam_rootok.so">/etc/pam.d/su -f
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    if id -u xtest >/dev/null 2>&1; then
        echo "xtest exists"
    else
        useradd xtest>/tmp/null 2>&1
    fi
    echo xtest:123!Edcd| chpasswd  
    SSH_CMD  "su xtest;" ${NODE1_IPV4} ${NODE1_PASSWORD} ${NODE1_USER}  20 22
    if [ "$?" == "0" ]; then
    	varflag="1"
    else
	varflag=0
    fi
    CHECK_RESULT $varflag "0" "0" "failed to set /etc/pam.d/su pam_rootok.so"
    LOG_INFO "Finish test!"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    userdel -rf xtest 
    mv /etc/pam.d/su_bak /etc/pam.d/su -f
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
