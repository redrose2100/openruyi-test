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
#@Date      	:   2024-01-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    MODIFY_INI redis_host ""
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code."
    CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set redis_host=''."
    journalctl -u pkgship -n 20 | grep "\[ERROR\] The value of below config names is None in: /etc/pkgship/package.ini, Please check these parameters:"
    CHECK_RESULT $? 0 0 "Check start value of below when set redis_host=''."
    journalctl -u pkgship -n 20 | grep "redis_host"
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when set redis_host=''."
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1" | grep "\[ERROR\] The value of below config names is None in: /etc/pkgship/package.ini, Please check these parameters"
    CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set redis_host=''."
    su pkgshipuser -c "pkgshipd stop >/dev/null"

    sed -i '/redis_host/d' "${SYS_CONF_PATH}"/package.ini
    systemctl start pkgship 2>&1 | grep "Job for pkgship.service failed because the control process exited with error code."
    journalctl -u pkgship -n 20 | grep "\[Warning\] Can not find config name 'redis_host' or 'redis_port' in: /etc/pkgship/package.ini,Please check the file"
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete redis_host"
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1" > pkgshipd.log
    grep "\[Warning\] Can not find config name 'redis_host' or 'redis_port' in: /etc/pkgship/package.ini,Please check the file" pkgshipd.log
    CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete redis_host"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    su pkgshipuser -c "pkgshipd stop >/dev/null"
    rm -rf "${SYS_CONF_PATH}"/package.ini pkgshipd.log
    mv "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
