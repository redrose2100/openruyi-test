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
#@Date          :   2025-09-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager numactl"
    systemctl restart oeaware
    oeawarectl -i numafast
    cp /etc/numafast.yaml_bak /etc/numafast.yaml_bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    numafast -w c > numafast.log &
    pkill -9 numafast
    grep "load-way: c" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -w failed"
    numafast --load-way c > numafast.log &
    pkill -9 numafast
    grep "load-way: c" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --load-way failed"
    numafast --smt off > numafast.log &
    pkill -9 numafast
    grep "smt: off" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --smt failed"
    numafast -v | grep "numafast version: "
    CHECK_RESULT $? 0 0 "Error: Check numafast -v failed"
    numafast --version | grep "numafast version: "
    CHECK_RESULT $? 0 0 "Error: Check numafast --version failed"
    numafast -W test,top,redis > numafast.log &
    pkill -9 numafast
    grep -F "whitelist: [top, redis, test]" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -W failed"
    numafast --whitelist test,top,redis > numafast.log &
    pkill -9 numafast
    grep -F "whitelist: [top, redis, test]" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --whitelist failed"
    numafast -b test,top,redis > numafast.log &
    pkill -9 numafast
    grep -F "blacklist: [top, redis, test]" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -b failed"
    numafast --blacklist test,top,redis > numafast.log &
    pkill -9 numafast
    grep -F "blacklist: [top, redis, test]" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --blacklist failed"
    numafast --precise-load > numafast.log &
    pkill -9 numafast
    grep "precise-load: true" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --precise-load failed"
    numafast --mem-numa-aggregation > numafast.log &
    pkill -9 numafast
    grep "mem-numa-aggregation: true" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --mem-numa-aggregation failed"
    numafast --mem-balance > numafast.log &
    pkill -9 numafast
    grep "mem-balance: true" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --mem-balance failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf numafast.log
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
