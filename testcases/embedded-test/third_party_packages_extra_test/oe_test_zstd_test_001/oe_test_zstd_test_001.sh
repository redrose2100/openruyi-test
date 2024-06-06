#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhang beibei
#@Contact       :   zhang_beibei@hoperun.com
#@Date          :   2024-04-30 17:10:01
#@License       :   Mulan PSL v2
#@Desc          :   test zstd
#####################################
# shellcheck disable=SC1091,SC3044,SC2039

source "$OET_PATH/testcases/embedded-test/third_party_packages_extra_test/comm_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    # zstd 在高压缩比(20+)的情况下，内存使用量大, 在内存1G的情况下，会触发out of memory错误。 所以跳过了这行测试。 
    sed -i "s/^roundTripTest -g2M \"22 --single-thread --ultra --long\"/# &/" ./tmp_test/tests/playTests.sh

    LOG_INFO "End to prepare the test environment."
}



# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/tests/ || exit 1
    
    EXE_PREFIX="" ZSTD_BIN="$(which zstd)" DATAGEN_BIN=./datagen ./playTests.sh > playTests.log 2>&1
    test_stat=$?
    
    if [ $test_stat -ne 0 ]; then
        # 输出错误日志
        cat playTests.log
        CHECK_RESULT $test_stat 0 0 "run zstd test fail"        
    fi

    popd || true

    LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
