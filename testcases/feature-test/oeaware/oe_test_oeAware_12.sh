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
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    chmod 777 /usr/lib64/oeAware-plugin/libthread_collector.so
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_collector.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_collector.so error exist in server log"
    chmod 777 /usr/lib64/oeAware-plugin/libthread_scenario.so
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_scenario.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_scenario.so error exist in server log"
    chmod 777 /usr/lib64/oeAware-plugin/libthread_tune.so 
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_tune.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_tune.so error exist in server log"
    
    if [ "$NODE1_FRAME" == "aarch64" ]; then
        chmod 777 /usr/lib64/oeAware-plugin/libpmu.so
        systemctl restart oeaware
        SLEEP_WAIT 1
        grep "libpmu.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
        CHECK_RESULT $? 0 0 "libpmu.so error exist in server log"
    fi 

    chmod 400 /usr/lib64/oeAware-plugin/libthread_collector.so
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_collector.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_collector.so error exist in server log"
    chmod 400 /usr/lib64/oeAware-plugin/libthread_scenario.so
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_scenario.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_scenario.so error exist in server log"
    chmod 400 /usr/lib64/oeAware-plugin/libthread_tune.so 
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "libthread_tune.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_tune.so error exist in server log"

    if [ "$NODE1_FRAME" == "aarch64" ]; then
        chmod 400 /usr/lib64/oeAware-plugin/libpmu.so
        systemctl restart oeaware
        SLEEP_WAIT 1
        grep "libpmu.so plugin preload failed, because plugin file permission is not the specified permission" /var/log/oeAware/server.log
        CHECK_RESULT $? 0 0 "libpmu.so error exist in server log"
    fi    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    chmod 440 -R /usr/lib64/oeAware-plugin/
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
