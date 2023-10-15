#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangshaowei
# @Contact   :   756800989@qq.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hwloc-gather-topology,hwloc-diff
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lstopo -l --input "node:1 2" ./new.xml
    lstopo -l --input 'node:1 2' ./old.xml
    hwloc-diff old.xml new.xml | grep 'topologydiff refname="old.xml"'
    CHECK_RESULT $? 0 0 "hwloc-diff failed"
    hwloc-diff --refname testname old.xml new.xml | grep 'refname="testname"'
    CHECK_RESULT $? 0 0 "hwloc-diff --refname failed"
    hwloc-diff --version | grep "hwloc-diff"
    CHECK_RESULT $? 0 0 "hwloc-diff --version failed"
    hwloc-gather-topology --io tep && ls | grep "tep.xml"
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --io failed"
    hwloc-gather-topology --dmi tep && ls | grep "tep.output" 
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --dmi failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf *.xml tep*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
