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
#@Date      	:   2024-01-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak
    ACT_SERVICE stop

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    MODIFY_INI remote_host 'http://127.0.0.2:8090'
    pkgship dbs -remote 2>&1 | grep "There seems to be a problem with the service" >/dev/null
    CHECK_RESULT $? 0 0 "Check failed when remote_host = http://127.0.0.2:8090"

    MODIFY_INI remote_host 'https.www.baidu.com' 
    pkgship dbs -remote 2>&1 | grep "Invalid URL" >/dev/null
    CHECK_RESULT $? 0 0 "Check failed when remote_host = https.www.baidu.com"

    MODIFY_INI remote_host '@#$$%^&&'
    pkgship dbs -remote 2>&1 | grep "Invalid URL" >/dev/null
    CHECK_RESULT $? 0 0 "Check failed when remote_host = @#$$%^&&"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${SYS_CONF_PATH}"/package.ini
    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
