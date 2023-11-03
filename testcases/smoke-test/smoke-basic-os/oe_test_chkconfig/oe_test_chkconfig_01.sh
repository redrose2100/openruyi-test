#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.3.3
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-chkconfig
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "chkconfig network-scripts"
    lang=$(echo $LANG)
    LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    chkconfig -v |grep chkconfig
    CHECK_RESULT $? 0 0 "version display failure"
    chkconfig -h 2>&1 | grep usage
    CHECK_RESULT $? 0 0 "help information fails to be displayed"
    chkconfig --del network
    chkconfig --list | grep "network"
    CHECK_RESULT $? 1 0 "service deletion failure"
    chkconfig --add network
    CHECK_RESULT $? 0 0 "service added failure"
    chkconfig --level 6 network on
    chkconfig --list | grep "network" | grep "6:on"
    CHECK_RESULT $? 0 0 "on status setting failure"
    chkconfig --level 6 network off
    chkconfig --list | grep "network" | grep "6:off"
    CHECK_RESULT $? 0 0 "off status setting failure"
}

function post_test() {
    DNF_REMOVE
    LANG=$lang
}

main $@
