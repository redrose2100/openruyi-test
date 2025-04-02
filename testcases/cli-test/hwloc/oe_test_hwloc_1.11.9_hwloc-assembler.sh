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
#@Date          :   2022-09-05
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-assembler
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    test -d tmp || mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    hwloc-assembler ./tmp/output.xml --name host1 ./common/host1.xml --name host2 ./common/host2.xml && grep "host1" tmp/output.xml
    CHECK_RESULT $? 0 0 "hwloc-assembler --name  failed" 
    hwloc-assembler ./tmp/output1.xml -n host1 ./common/host1.xml -n host2 ./common/host2.xml && grep "host1" tmp/output1.xml
    CHECK_RESULT $? 0 0 "hwloc-assembler -n failed"
    hwloc-assembler --force ./tmp/output2.xml ./common/host1.xml ./common/host2.xml && [ -e tmp/output2.xml ]
    CHECK_RESULT $? 0 0 "hwloc-assembler --force  failed"
    hwloc-assembler -f ./tmp/output3.xml ./common/host1.xml ./common/host2.xml && [ -e tmp/output3.xml ]
    CHECK_RESULT $? 0 0 "hwloc-assembler -f failed"
    hwloc-assembler --verbose ./tmp/output4.xml --name host1 ./common/host1.xml --name host2 ./common/host2.xml | grep "Importing"
    CHECK_RESULT $? 0 0 "hwloc-assembler --verbose  failed"
    hwloc-assembler -v ./tmp/output5.xml --name host1 ./common/host1.xml --name host2 ./common/host2.xml | grep "Importing"
    CHECK_RESULT $? 0 0 "hwloc-assembler -v failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
