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
    used_port=$(netstat -anp | grep root | awk '{print $4}' | head -n 1 | cut -d : -f 2)
    para=('65537' "$used_port")
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    for i in $(seq 0 $((${#para[@]} - 1))); do
        MODIFY_INI redis_port "${para[$i]}"
        systemctl start pkgship
        journalctl -u pkgship -n 10 | grep "\[WARNING\] redis is unavailable and the installation process continues, which may cause slow queries"
        CHECK_RESULT $? 0 0 "Check failed by systemctl when redis_port=${para[$i]}"
        ACT_SERVICE stop
        su pkgshipuser -c "pkgshipd start 2>&1" > pkgshipd.log
        grep "\[WARNING\] redis is unavailable and the installation process continues, which may cause slow queries" pkgshipd.log
        CHECK_RESULT $? 0 0 "Check failed by pkgshipd when redis_port=${para[$i]}"
        su pkgshipuser -c "pkgshipd stop >/dev/null"
        rm -rf pkgshipd.log
    done
    MODIFY_INI redis_port 'test^#'
    systemctl start pkgship
    journalctl -u pkgship -n 10 | grep "\[ERROR\] redis_port should be a number,please check this parameter"
    CHECK_RESULT $? 0 0 "Check failed by systemctl when redis_port=test^#"
    ACT_SERVICE stop
    su pkgshipuser -c "pkgshipd start 2>&1" > pkgshipd.log
    grep "\[ERROR\] redis_port should be a number,please check this parameter" pkgshipd.log
    CHECK_RESULT $? 0 0 "Check failed by pkgshipd when redis_port=test^#"
    su pkgshipuser -c "pkgshipd stop >/dev/null"
    rm -rf pkgshipd.log
    
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
