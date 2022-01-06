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
#@Author    	:   yanglijin/limeiting
#@Contact   	:   1050472997@qq.com/244349477@qq.com
#@Date      	:   2021-02-20
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################

source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    mv ${SYS_CONF_PATH}/package.ini ${SYS_CONF_PATH}/package.ini.bak
    cp -p ./package.ini ${SYS_CONF_PATH}/package.ini
    cp -p ./conf.html ../../conf.html
    chown pkgshipuser:pkgshipuser ${SYS_CONF_PATH}/package.ini conf.html ../../conf.html
    ACT_SERVICE

    LOG_INFO "Finish to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship init -filepath conf.html >/dev/null
    pkgship dbs | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "openeuler init failed."
    pkgship init -filepath ./conf.html >/dev/null
    pkgship dbs | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "openeuler init failed."
    pkgship init -filepath ../../conf.html >/dev/null
    pkgship dbs | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "openeuler init failed."
    grep "INFO" ${LOG_PATH}/pkgship/log_info.log
    CHECK_RESULT $? 1 0 "The log contains INFO."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f /home/pkgshipuser/log/uwsgi.html ../../conf.html ${SYS_CONF_PATH}/package.ini 
    mv ${SYS_CONF_PATH}/package.ini.bak ${SYS_CONF_PATH}/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main $@
