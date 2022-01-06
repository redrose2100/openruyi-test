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
#@Date      	:   2021-03-11
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

    MODIFY_INI backup_count ""
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code." &&
    journalctl -u pkgship -n 20 | grep "\[ERROR\] The value of below config names is None in: /etc/pkgship/package.ini, Please check these parameters:" &&
    journalctl -u pkgship -n 20 | grep "backup_count"
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when set backup_count=''."
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1 | grep \"\[ERROR\] The value of below config names is None in: /etc/pkgship/package.ini, Please check these parameters:\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set backup_count=''."
    su pkgshipuser -c "pkgshipd stop >/dev/null"

    sed -i '/backup_count/d' ${SYS_CONF_PATH}/package.ini
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code." &&
    journalctl -u pkgship -n 20 | grep "\[ERROR\] Configuration parameters 'max_bytes' or 'backup_count' do not exist"
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete backup_count"
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1 | grep \"\[ERROR\] Configuration parameters 'max_bytes' or 'backup_count' do not exist\""
    CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete backup_count"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    su pkgshipuser -c "pkgshipd stop >/dev/null"
    mv ${SYS_CONF_PATH}/package.ini.bak ${SYS_CONF_PATH}/package.ini
    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main $@
