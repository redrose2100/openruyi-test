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
#@Date          :   2024-05-08 17:15:51
#@License       :   Mulan PSL v2
#@Desc          :   test yajl
#####################################
# shellcheck disable=SC1091,SC3044,SC2039

source "$OET_PATH/testcases/embedded-test/third_party_packages_test/comm_lib.sh"


# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/test/parsing/ || exit 5
    ./run_tests.sh ../../build/test/parsing/yajl_test > yajl.test.log 2>&1
    test_stat=$?
    
    if [ $test_stat -ne 0 ]; then
        # 输出错误日志
        cat yajl.test.log
        CHECK_RESULT $test_stat 0 0 "run yajl parsing test fail"      
    fi
    popd || ture

    pushd ./tmp_test/build/test/api/ || exit 5
    ../../../test/api/run_tests.sh > yajl.test.log 2>&1
    test_stat=$?
    
    if [ $test_stat -ne 0 ]; then
        # 输出错误日志
        cat yajl.test.log
        CHECK_RESULT $test_stat 0 0 "run yajl api test fail"     
    fi
    
    popd || ture

    LOG_INFO "End to run test."
}


function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
