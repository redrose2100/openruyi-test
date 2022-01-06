#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2021-02-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################

source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    cp -p ${SYS_CONF_PATH}/package.ini ${SYS_CONF_PATH}/package.ini.bak
    ACT_SERVICE stop

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    MODIFY_INI query_port 65537
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code." &&
        journalctl -u pkgship -n 20 | grep "\[ERROR\] Invalid port of 65537"
    CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is 65537 failed."
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1 | grep \"\[ERROR\] Invalid port of 65537\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is 65537 failed."
    su pkgshipuser -c "pkgshipd stop >/dev/null"

    MODIFY_INI query_port "test^#"
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code." &&
        journalctl -u pkgship -n 20 | grep "\[ERROR\] port should be a number"
    ACT_SERVICE stop
    CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is test^# failed."
    su pkgshipuser -c "pkgshipd start 2>&1 | grep \"\[ERROR\] port should be a number\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is test^# failed."
    su pkgshipuser -c "pkgshipd stop >/dev/null"

    used_port=$(netstat -anp | grep root | awk '{print $4}' | head -n 1 | cut -d : -f 2)
    MODIFY_INI query_port $used_port
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code." &&
        journalctl -u pkgship -n 20 | grep "\[ERROR\] Invalid port of $used_port"
    CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is used_port failed."
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1 | grep \"\[ERROR\] Invalid port of $used_port\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is used_port failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    su pkgshipuser -c "pkgshipd stop >/dev/null"
    rm -f ${SYS_CONF_PATH}/package.ini
    mv ${SYS_CONF_PATH}/package.ini.bak ${SYS_CONF_PATH}/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main $@

