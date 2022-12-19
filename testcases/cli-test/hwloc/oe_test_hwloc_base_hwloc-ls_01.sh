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
# @Author    :   zhangshaowei
# @Contact   :   756800989@qq.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hwloc-ls
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
    hwloc-ls -f out.xml && ls | grep "out.xml"
    CHECK_RESULT $? 0 0 "hwloc-ls -f failed"
    hwloc-ls -l | grep "L#0"
    CHECK_RESULT $? 0 0 "hwloc-ls -l failed"
    hwloc-ls -p | grep "P#0"
    CHECK_RESULT $? 0 0 "hwloc-ls --physical or -p failed"
    hwloc-ls --of fig | grep "FIG"
    CHECK_RESULT $? 0 0 "hwloc-ls --output-format or --of failed"
    hwloc-ls --only PU | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --only failed"
    hwloc-ls -v | grep "PCI"
    CHECK_RESULT $? 0 0 "hwloc-ls -v or --verbose"
    hwloc-ls -c | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls -c or  --cpuset"
    hwloc-ls -C | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-ls -C failed"
    hwloc-ls --export-synthetic-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --export-synthetic-flag  failed"
    hwloc-ls -s | grep "depth 0"
    CHECK_RESULT $? 0 0 "hwloc-ls -s  or --silent  failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -f out.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"