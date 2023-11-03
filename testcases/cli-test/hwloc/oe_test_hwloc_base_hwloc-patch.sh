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
# @Desc      :   Test hwloc-patch
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
    mkdir tmp
    hwloc-patch --reverse ./common/topo.xml ./common/diff.xml ./tmp/output--reverse.xml && cat ./tmp/output--reverse.xml
    CHECK_RESULT $? 0 0 "hwloc-patch --reverse failed"
    hwloc-patch -R ./common/topo.xml ./common/diff.xml ./tmp/output-R.xml && cat ./tmp/output-R.xml
    CHECK_RESULT $? 0 0 "hwloc-patch -R failed"
    hwloc-patch --version | grep "hwloc-patch"
    CHECK_RESULT $? 0 0 "hwloc-calc --version failed"
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