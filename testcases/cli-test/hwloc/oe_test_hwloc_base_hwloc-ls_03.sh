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
    hwloc-ls --whole-io | grep "PCI"
    CHECK_RESULT $? 0 0 "hwloc-ls --whole-io failed"
    hwloc-ls  -i / | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls -i failed"
    hwloc-ls -i "node:2 2"| grep "NUMANode L#1"
    CHECK_RESULT $? 0 0 "hwloc-ls -i 'node:2 2' failed"
    lstopo ./test_1.xml
    hwloc-ls -i ./test_1.xml | grep "PCI"
    CHECK_RESULT $? 0 0 "hwloc-ls -i failed"
    hwloc-ls --no-io | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-io  failed"
    hwloc-ls --no-bridges | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --no-bridges  failed"
    hwloc-ls --if fsroot | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --if  failed"
    hwloc-ls --thissystem | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --thissystem  failed"
    hwloc-ls --ps | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --ps failed"
    hwloc-ls --version | grep "hwloc-ls"
    CHECK_RESULT $? 0 0 "hwloc-ls --version failed"
    LOG_INFO "Finish test!"
}
function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test_1.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"