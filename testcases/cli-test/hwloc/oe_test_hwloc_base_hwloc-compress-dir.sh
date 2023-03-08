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
# @Desc      :   Test hwloc-compress-dir hwloc-gather-topology
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
    mkdir ./raw ./compress ./uncompress
    lstopo -l --input "node:1 2" ./raw/test1.xml
    lstopo -l --input 'node:1 2' ./raw/test2.xml
    lstopo -l --input 'node:2 2' ./raw/test3.xml
    hwloc-compress-dir --verbose ./raw/ ./compress/ 
    cd compress/ && ls | wc -w | grep "3" && cd ../
    CHECK_RESULT $? 0 0 "hwloc-compress-dir --verbose failed"
    hwloc-compress-dir -v ./raw/ ./compress/ | grep "already non-compressed"
    CHECK_RESULT $? 0 0 "hwloc-compress-dir -v failed"
    cd compress/
    ls | grep "diff.xml"
    CHECK_RESULT $? 0 0 "hwloc-compress-dir -v failed"
    cd ../
    hwloc-compress-dir -R ./compress/ ./uncompress/ | grep "Uncompressed"
    CHECK_RESULT $? 0 0 "hwloc-compress-dir -R failed"
    hwloc-compress-dir --reverse ./compress/ ./uncompress/ | grep "Uncompressed 0"
    CHECK_RESULT $? 0 0 "hwloc-compress-dir --reverse failed"
    cd uncompress/
    ls | grep 'test2.xml'
    CHECK_RESULT $? 0 0 "hwloc-compress-dir --reverse failed"
    LOG_INFO "Finish test!"
    
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../raw ../compress ../uncompress
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}


main "$@"
