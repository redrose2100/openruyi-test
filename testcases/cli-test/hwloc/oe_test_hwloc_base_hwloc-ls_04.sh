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
    hwloc-ls --force out.xml && ls | grep "out.xml"
    CHECK_RESULT $? 0 0 "hwloc-ls -f failed"
    hwloc-ls --logical | grep "L#0"
    CHECK_RESULT $? 0 0 "hwloc-ls --logical failed"
    hwloc-ls --physical | grep "P#0"
    CHECK_RESULT $? 0 0 "hwloc-ls --physical failed"
    hwloc-ls --output-format fig | grep "FIG"
    CHECK_RESULT $? 0 0 "hwloc-ls --output-format failed"
    hwloc-ls --verbose | grep "PCI"
    CHECK_RESULT $? 0 0 "hwloc-ls --verbose failed"
    hwloc-ls  --cpuset  | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --cpuset failed"
    hwloc-ls  --silent | grep "depth 0"
    CHECK_RESULT $? 0 0 "hwloc-ls --silent failed"
    hwloc-ls --cpuset-only | grep "0x00000" 
    CHECK_RESULT $? 0 0 "hwloc-ls --cpuset-only failed"
    lstopo ./test_1.xml
    hwloc-ls --input ./test_1.xml | grep "PCI"
    CHECK_RESULT $? 0 0 "hwloc-ls --input failed"
    hwloc-ls  --input / | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --input failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -f *.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"