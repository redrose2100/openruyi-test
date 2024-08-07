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
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    chmod 777 /var/run/oeAware/oeAware-sock
    systemctl restart oeaware
    SLEEP_WAIT 1
    stat /var/run/oeAware/oeAware-sock | grep "0750"
    CHECK_RESULT $? 0 0 "Error: file permission is wrong"
    oeawarectl -q | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "Error: command oeawarectl -q"

    chmod 400 /var/run/oeAware/oeAware-sock
    systemctl restart oeaware
    SLEEP_WAIT 1
    stat /var/run/oeAware/oeAware-sock | grep "0750"
    CHECK_RESULT $? 0 0 "Error: file permission is wrong"
    oeawarectl -q | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "Error: command oeawarectl -q"

    mv /var/run/oeAware/oeAware-sock /var/run/oeAware/oeAware-sock1
    oeawarectl -q | grep "can't connect to server"
    CHECK_RESULT $? 0 0 "Error: sock file is wrong"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /var/run/oeAware/oeAware-sock1 /var/run/oeAware/oeAware-sock
    systemctl restart oeaware
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
