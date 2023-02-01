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
#@Desc          :   Test hwloc-annotate
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    test -d tmp || mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    hwloc-annotate --ri ./common/input.xml ./tmp/output.xml Core:all info infoname infovalue && diff ./common/input.xml ./tmp/output.xml
    CHECK_RESULT $? 1 0 "hwloc-annotate --ri failed"
    hwloc-annotate --ci ./common/input.xml ./tmp/output1.xml Core:all info infoname infovalue && diff ./common/input.xml ./tmp/output1.xml
    CHECK_RESULT $? 1 0 "hwloc-annotate --ci failed"
    hwloc-annotate --cu ./common/input.xml ./tmp/output2.xml Core:all info infoname infovalue && diff ./common/input.xml ./tmp/output2.xml
    CHECK_RESULT $? 1 0 "hwloc-annotate --cu failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp 
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
