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
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   set parameter plugin_path test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! test -d /sys/fs/cgroup/cpu/watt_sched; then
        echo "the environment is not support!"
        exit 0
    fi
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_config.ini /etc/eagle/eagle_config.ini_bak
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    mkdir plugin
    cp -r -p /etc/eagle/plugin/* plugin
    mv /etc/eagle/plugin /etc/eagle/plugin_bak 
    sed -i 's/config_update_interval=.*/config_update_interval=5/' /etc/eagle/eagle_config.ini
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's#plugin_path=.*#plugin_path='"$(pwd)"'/plugins#' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 80
    grep "plugin_path in config is invalid. ret:4" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check plugin_path is not exists failed"

    sed -i 's#plugin_path=.*#plugin_path='"$(pwd)"'/plugin#' /etc/eagle/eagle_config.ini
    sed -i 's/watt_threshold =.*/watt_threshold = 37/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep 37 /proc/sys/kernel/sched_util_low_pct
    CHECK_RESULT $? 0 0 "Check plugin_path is exists failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_config.ini_bak /etc/eagle/eagle_config.ini
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    rm -rf plugin
    mv /etc/eagle/plugin_bak /etc/eagle/plugin
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
