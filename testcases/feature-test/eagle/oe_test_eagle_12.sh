#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   set parameter desc test
####################################
# shellcheck disable=SC2002

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/desc=.*/desc=/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "desc" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check desc is null failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/desc=.*/desc=12abc_s- !@#$%^&*/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "desc" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check desc failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/desc=.*/desc=a/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "desc" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check desc length is 1 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/desc=.*/desc='"$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 255 | head -n 1)"'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "desc" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check desc length is 255 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/desc=.*/desc='"$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 256 | head -n 1)"'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "desc" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check desc length is 256 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
