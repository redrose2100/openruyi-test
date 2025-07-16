#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhangshaowei
#@Contact       :   756800989@qq.com
#@Date          :   2022-08-09
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-distances
#####################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/hwloc/common/checkenv.sh"


function pre_test()
{
    # 判断 hwloc 版本是否为1.11.9, 如果不是skip退出
    checkversion1119
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start testing..."
    hwloc-distances -l -i ./common/distances_test.xml | grep "below Machine L#0"
    CHECK_RESULT $? 0 0 "hwloc-distances -l  failed"
    hwloc-distances -p -i ./common/distances_test.xml | grep "below Machine P#0"
    CHECK_RESULT $? 0 0 "hwloc-distances -p  failed"
    hwloc-distances -i ./common/distances_test.xml --restrict 0x0000ffff | grep "below Group0 L#0"
    CHECK_RESULT $? 0 0 "hwloc-distances --restrict failed"
    hwloc-distances -i ./common/distances_test.xml --whole-system | grep "below Group0 L#0"
    CHECK_RESULT $? 0 0 "hwloc-distances --whole-system failed"
    hwloc-distances -i ./common/input_test.xml --verbose | grep "input_test.xml" 
    CHECK_RESULT $? 0 0 "hwloc-distances -i <XML file> failed"
    hwloc-distances -i /root --verbose | grep "/root"
    CHECK_RESULT $? 0 0 "hwloc-distances -i <directory> failed"
    hwloc-distances --input "node:2 2" --verbose | grep "node:2 2"
    CHECK_RESULT $? 0 0 "hwloc-distances --input 'node:2 2' failed"
    hwloc-distances -i ./common/input_test.xml --if fsroot 2>&1 | grep "Not a directory"
    CHECK_RESULT $? 0 0 "hwloc-distances  --if <format> failed"
    hwloc-distances --input "node:2 2" -v | grep "assuming"
    CHECK_RESULT $? 0 0 "hwloc-distances -v failed"
    hwloc-distances --version | grep "hwloc-distances"
    CHECK_RESULT $? 0 0 "hwloc-distances --version failed"
    LOG_INFO "Finish test!"
}


function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}


main "$@"

