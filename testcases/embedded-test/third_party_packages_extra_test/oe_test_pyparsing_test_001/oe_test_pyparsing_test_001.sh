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
#@Date          :   2024-05-17 17:45:54
#@License       :   Mulan PSL v2
#@Desc          :   test pyparsing
#####################################
# shellcheck disable=SC1091,SC3044,SC2039

source "$OET_PATH/testcases/embedded-test/third_party_packages_extra_test/comm_lib.sh"


# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/ || exit 5
    
    python3 tests/test_simple_unit.py
    CHECK_RESULT $? 0 0 "run pyparsing test fail"

    popd || true

    LOG_INFO "End to run test."
}

main "$@"
