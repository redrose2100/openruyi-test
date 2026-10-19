#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li,Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-03-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Check logrotate
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    MODIFY_INI max_bytes "10" && MODIFY_INI backup_count "3"
    CHECK_RESULT $? 0 0 "Change package.ini failed."
    ACT_SERVICE restart
    for i in $(seq 1 5); do
        pkgship installdep ABCDEFD_DONET_EXIST >/dev/null
        CHECK_RESULT $? 0 0 "check $i pkgship installdep."
    done

    find "${LOG_PATH}"/pkgship/log_info.log.*.gz
    CHECK_RESULT $? 0 0 "log_info rotate failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${LOG_PATH}"/pkgship/log_info.log.rotate* "${SYS_CONF_PATH}"/package.ini
    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
