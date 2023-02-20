#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

##############################################
#@Author    :   zhangshaowei
#@Contact   :   756800989@qq.com
#@Date      :   2022/07/26
#@License   :   Mulan PSL v2
#@Desc      :   Test hwloc-ls,lstopo,lstopo-no-graphics,hwloc-patch,hwloc-diff
##############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-ls --help | grep "Usage: hwloc-ls" 
    CHECK_RESULT $? 0 0 "hwloc-ls --help failed"
    hwloc-ls -l --export-xml-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ls --export-xml-flags failed"
    lstopo --help | grep "Usage: lstopo" 
    CHECK_RESULT $? 0 0 "lstopo --help failed"
    lstopo -l --export-xml-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo --export-xml-flags failed"
    lstopo-no-graphics --help | grep "Usage: lstopo-no-graphics" 
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --help failed "
    lstopo-no-graphics -l --export-xml-flags 1 | grep "Machine"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --export-xml-flags failed "
    hwloc-patch -h | grep "Usage: hwloc-patch"
    CHECK_RESULT $? 0 0 "hwloc-patch -h failed"
    hwloc-patch --help | grep "Usage: hwloc-patch"
    CHECK_RESULT $? 0 0 "hwloc-patch --help failed"
    hwloc-diff -h | grep "hwloc-diff \[options\]" 
    CHECK_RESULT $? 0 0 "hwloc-diff --help failed"
    hwloc-diff --help | grep "hwloc-diff \[options\]"
    CHECK_RESULT $? 0 0 "hwloc-diff -h failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"