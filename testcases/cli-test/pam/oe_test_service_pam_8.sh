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
    useradd xtest>/tmp/null 2>&1
    echo xtest:123| chpasswd  
    cp -y /etc/security/limits.conf /etc/security/limits_bak.conf
    echo "test hard maxlogins 4" >/etc/security/limits.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    kill `netstat -anp | grep :22| grep xtest | awk '{print $7}' | awk -F"/" '{print $1}'`
    nohup ssh xtest@localhost &
    CHECK_RESULT $?
    nohup ssh xtest@localhost &
    CHECK_RESULT $?
    nohup ssh xtest@localhost &
    CHECK_RESULT $?
    nohup ssh xtest@localhost &
    CHECK_RESULT $?
    SSH_CMD "echo hello;" 127.0.0.1  123 xtest  20 22
    if [ "$?" == "0" ]; then
        varflag="0"
    else
        varflag=1
    fi
    CHECK_RESULT $varflag "1"
    LOG_INFO "Finish test!"
}

function post_test(){
    mv /etc/security/limits_bak.conf /etc/security/limits.conf
}
main "$@"
