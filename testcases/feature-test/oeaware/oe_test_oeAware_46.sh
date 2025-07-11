#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################
# shellcheck disable=SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    DNF_INSTALL "oeAware-manager patchelf gcc"
    systemctl start oeaware
    gcc -shared -fPIC common/libhello.c -o libhello.so
    gcc common/main.c -o main
    cp /etc/oeAware/preload.yaml /etc/oeAware/preload.yaml_bak
    echo ' - apppath: "'$(pwd)'/main"
   sopath:
     - "'$(pwd)'/libhello.so"
     - "/usr/lib64/libc.so.6"' > /etc/oeAware/preload.yaml
    echo > /var/log/oeAware/server.log
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e preload_tune | grep "Instance enabled failed, because instance init environment failed"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune enable failed"
    grep "shared object libc.so.6 already exists in $(pwd)/main" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "Error: Check preload_tune enable failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf libhello* main
    mv -f /etc/oeAware/preload.yaml_bak /etc/oeAware/preload.yaml
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
