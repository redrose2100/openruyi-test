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
#@Desc          :   set parameter file_size cmp_cnt test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_config.ini /etc/eagle/eagle_config.ini_bak
    echo "while true
do
  systemctl restart eagle
  sleep 1.5
done" > test.sh
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sed -i 's/file_size=.*/file_size=1/' /etc/eagle/eagle_config.ini
    sed -i 's/cmp_cnt=.*/cmp_cnt=2/' /etc/eagle/eagle_config.ini
    sh test.sh &
    SLEEP_WAIT 1200
    num=$(find /var/log/eagle/bak -name 'eagle.log*' | wc -l)
    test "${num}" -eq 2
    CHECK_RESULT $? 0 0 "Check file_size cmp_cnt failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 "$(pgrep -f test.sh)"
    mv -f /etc/eagle/eagle_config.ini_bak /etc/eagle/eagle_config.ini
    rm -rf test.sh
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
