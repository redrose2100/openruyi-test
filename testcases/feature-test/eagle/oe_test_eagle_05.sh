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
#@Desc          :   set parameter bak_log_path test
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
    mkdir bak
    chmod 777 bak
    echo "while true
do
  systemctl restart eagle
  sleep 1.5
done" > test.sh
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sed -i 's#bak_log_path=.*#bak_log_path='"$(pwd)"'/bak#' /etc/eagle/eagle_config.ini
    sed -i 's/file_size=.*/file_size=1/' /etc/eagle/eagle_config.ini
    sh test.sh &
    SLEEP_WAIT 500
    ls "$(pwd)"/bak
    num=$(find "$(pwd)"/bak -name 'eagle.log*' | wc -l)
    test "${num}" -ge 1
    CHECK_RESULT $? 0 0 "Check bak_log_path failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 "$(pgrep -f test.sh)"
    mv -f /etc/eagle/eagle_config.ini_bak /etc/eagle/eagle_config.ini
    rm -rf bak test.sh
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
