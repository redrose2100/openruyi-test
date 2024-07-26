#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @modify    :   wangxiaoya@qq.com
# @Date      :   2022/05/12
# @License   :   Mulan PSL v2
# @Desc      :   Adjusted the strategy for sharing nfs and cifs volumes using SELinux booleands
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "setroubleshoot-server policycoreutils-python-utils"
    DNF_INSTALL "setroubleshoot-server policycoreutils-python-utils" 2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    semanage boolean -l | grep httpd_use_nfs | grep off
    CHECK_RESULT $?
    semanage boolean -l | grep httpd_use_cifs | grep off
    CHECK_RESULT $?
    getsebool -a | grep httpd_use_nfs | grep off
    CHECK_RESULT $?
    getsebool -a | grep httpd_use_cifs | grep off
    CHECK_RESULT $?
    setsebool httpd_use_nfs on
    setsebool httpd_use_cifs on
    semanage boolean -l | grep httpd_use_nfs | grep on
    CHECK_RESULT $?
    semanage boolean -l | grep httpd_use_cifs | grep on
    CHECK_RESULT $?
    P_SSH_CMD --node 2 --cmd "setsebool -P httpd_use_nfs on;setsebool -P httpd_use_cifs on"
    P_SSH_CMD --node 2 --cmd "semanage boolean -l | grep httpd_use_nfs | grep on"
    CHECK_RESULT $?
    P_SSH_CMD --node 2 --cmd "semanage boolean -l | grep httpd_use_cifs| grep on"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    setsebool httpd_use_nfs off
    setsebool httpd_use_cifs off
    P_SSH_CMD --node 2 --cmd "setsebool -P httpd_use_nfs off;setsebool -P httpd_use_cifs off"
    DNF_REMOVE "$@"
    DNF_REMOVE 2 "setroubleshoot-server"
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
