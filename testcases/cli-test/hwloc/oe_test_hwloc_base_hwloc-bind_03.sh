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
#@Date          :   2022-08-15
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-bind
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    hwloc-bind --physical core:0 hwloc-info | grep "Package"
    CHECK_RESULT $? 0 0 "hwloc-bind --physical failed"
    hwloc-bind --force core:0 hwloc-ps -a | grep 'hwloc-ps'
    CHECK_RESULT $? 0 0 "hwloc-bind ---force failed"
    hwloc-bind --no-hbm core:0 hwloc-info | grep "depth"
    CHECK_RESULT $? 0 0 "hwloc-bind --no-hbm failed"
    hwloc-bind --verbose echo 'hello' | grep "hello"
    CHECK_RESULT $? 0 0 "hwloc-bind --verbose failed"
    hwloc-bind -e | grep '0x0000'
    CHECK_RESULT $? 0 0 "hwloc-bind -e failed"
    hwloc-bind --get-last-cpu-location | grep '0x0000'
    CHECK_RESULT $? 0 0 "hwloc-bind --get-last-cpu-location failed"
    hwloc-bind --quiet core:0 echo 'hwloc-bind' | grep "hwloc-bind"
    CHECK_RESULT $? 0 0 "hwloc-bind --quiet failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
