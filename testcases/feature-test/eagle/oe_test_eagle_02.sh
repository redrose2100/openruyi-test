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
#@Desc          :   set parameter log_level test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_config.ini /etc/eagle/eagle_config.ini_bak
    sed -i 's/config_update_interval=.*/config_update_interval=5/' /etc/eagle/eagle_config.ini
    log=/var/log/eagle/eagle.log
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "DEBUG " "${log}" && grep "INFO " "${log}" && grep "ERROR PWRAPI" "${log}"
    CHECK_RESULT $? 0 0 "Check log_level=0 failed"
    SLEEP_WAIT 80
    echo > "${log}"
    sed -i 's/log_level=.*/log_level=1/' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 5
    cat "${log}"
    grep "INFO " "${log}" && grep "ERROR " "${log}"
    CHECK_RESULT $? 0 0 "Check log_level=1 failed"
    echo > "${log}"
    sed -i 's/log_level=.*/log_level=2/' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 5
    grep "ERROR " "${log}"
    CHECK_RESULT $? 0 0 "Check log_level=2 failed"
    echo > "${log}"
    sed -i 's/log_level=.*/log_level=3/' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 5
    grep "ERROR " "${log}"
    CHECK_RESULT $? 0 0 "Check log_level=3 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_config.ini_bak /etc/eagle/eagle_config.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
