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
#@Desc      	:   Check inject inode full for log
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    mv "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak
    cp -p ./package.ini "${SYS_CONF_PATH}"/package.ini
    chown pkgshipuser:pkgshipuser "${SYS_CONF_PATH}"/package.ini
    cp -p "${LOG_PATH}"/pkgship/log_info.log "${LOG_PATH}"/pkgship/log_info.log.bak

    ACT_SERVICE restart
    INIT_CONF ../../common_lib/openEuler.yaml
    bash "${OET_PATH}"/libs/fault_injection/inject_base/inject_full_inode/inject_full_inode.sh inject /tmp

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    pkgship dbs >/dev/null
    ls -l /tmp/log_info.log
    CHECK_RESULT $? 0 0 "There is no error msg on log when logrotate failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    bash "${OET_PATH}"/libs/fault_injection/inject_base/inject_full_inode/inject_full_inode.sh clean /tmp

    rm -rf "${LOG_PATH}"/pkgship/log_info.log
    mv "${LOG_PATH}"/pkgship/log_info.log.bak "${LOG_PATH}"/pkgship/log_info.log
    rm -rf "${SYS_CONF_PATH}"/package.ini
    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
