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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak
    ACT_SERVICE stop
    para=('2.5' '-11' 'test')

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    MODIFY_INI backup_count 0
    systemctl start pkgship 2>&1 | grep -q "Job for pkgship.service failed because the control process exited with error code."
    CHECK_RESULT $? 0 0 "Check pkgship.service failed when backup_count = ${para[$i]}."
    journalctl -u pkgship -n 20 | grep -q "\[ERROR\] The values of configuration parameters 'max_bytes' or 'backup_count' are less than or equal to 0, please make sure they are greater than 0"
    CHECK_RESULT $? 0 0 "Check start by systemctl when backup_count = ${para[$i]}."
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1 | grep -q \"\[ERROR\] The values of configuration parameters 'max_bytes' or 'backup_count' are less than or equal to 0, please make sure they are greater than 0\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd when backup_count = ${para[$i]}."
    su pkgshipuser -c "pkgshipd stop >/dev/null"

    for i in $(seq 0 $((${#para[@]} - 1))); do
        SLEEP_WAIT 2
        MODIFY_INI backup_count "${para[$i]}"
        systemctl start pkgship 2>&1 | grep -q "Job for pkgship.service failed because the control process exited with error code."
        CHECK_RESULT $? 0 0 "Check pkgship.service failed when backup_count = ${para[$i]}."
        journalctl -u pkgship -n 20 | grep -q "\[ERROR\] backup_count should be a number."
        CHECK_RESULT $? 0 0 "Check start by systemctl when backup_count = ${para[$i]}."
        ACT_SERVICE stop
        su pkgshipuser -c "pkgshipd start 2>&1 | grep -q \"\[ERROR\] backup_count should be a number.\""
        CHECK_RESULT $? 0 0 "Check start by pkgshipd when backup_count = ${para[$i]}."
        su pkgshipuser -c "pkgshipd stop >/dev/null"
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
