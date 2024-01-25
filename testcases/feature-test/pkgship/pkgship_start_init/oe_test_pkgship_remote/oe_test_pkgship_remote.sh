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
    LOG_INFO "Start to prepare the database config."

    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak
    ACT_SERVICE
    
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."   
    
    MODIFY_INI remote_host "https:\/\/api.openeuler.org\/pkgmanage"
    CHECK_RESULT $? 0 0 "Modify config file failed."

    pkgship -v -remote | grep "Version"
    CHECK_RESULT $? 0 0 "Check remote -v failed."
    pkgship dbs -remote | grep "openeuler"
    CHECK_RESULT $? 0 0 "Check remote dbs failed."

    dbname=$(pkgship dbs -remote | tail -n 1 | cut -d "'" -f 2)
    pkgship list "$dbname" -remote | grep "$dbname" >/dev/null
    CHECK_RESULT $? 0 0 "Check remote list failed."
    pkgship pkginfo Judy "$dbname" -remote | grep Judy >/dev/null
    CHECK_RESULT $? 0 0 "Check remote pkginfo failed."
    pkgship installdep Judy -remote | grep "$dbname" >/dev/null
    CHECK_RESULT $? 0 0 "Check remote installdep failed."
    pkgship builddep Judy -remote | grep "$dbname" >/dev/null
    CHECK_RESULT $? 0 0 "Check remote builddep failed."
    pkgship selfdepend Judy -remote | grep "$dbname" >/dev/null
    CHECK_RESULT $? 0 0 "Check remote selfdepend failed."
    pkgship bedepend "$dbname" Judy -remote | grep "$dbname" >/dev/null
    CHECK_RESULT $? 0 0 "Check remote bedepend failed."
    
    LOG_INFO "Start to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${SYS_CONF_PATH}"/package.ini
    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
