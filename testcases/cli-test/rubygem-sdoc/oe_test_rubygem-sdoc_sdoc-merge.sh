#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo 
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test sdoc-merge
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-sdoc tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sdoc-merge -h | grep "Usage: sdoc-merge"
    CHECK_RESULT $? 0 0 "Check sdoc-merge -h failed"
    pushd ./mergedata
    sdoc-merge -o tmp1 --title "Ruby v1.9, Rails v2.3.2.1"  rubydemo rails
    grep -risn "Ruby v1.9, Rails v2.3.2.1" ./tmp1/index.html 
    CHECK_RESULT $? 0 0 "Check sdoc-merge --title failed"
    sdoc-merge -o tmp2 -t "Ruby v1.9, Rails v2.3.2.1"  rubydemo rails
    grep -risn "Ruby v1.9, Rails v2.3.2.1" ./tmp2/index.html 
    CHECK_RESULT $? 0 0 "Check sdoc-merge -t failed"
    sdoc-merge -o tmp3 -u "testurldemo xxxx" rails rubydemo
    grep "testurldemo/files" ./tmp3/index.html 
    CHECK_RESULT $? 0 0 "Check sdoc-merge -u failed"
    sdoc-merge -o tmp4 --urls "testurldemo xxxx" rails rubydemo
    grep "testurldemo/files" ./tmp4/index.html 
    CHECK_RESULT $? 0 0 "Check sdoc-merge --urls failed"
    sdoc-merge --op tmpdemo1  rubydemo rails && test -d tmpdemo1
    CHECK_RESULT $? 0 0 "Check sdoc-merge --op failed"
    sdoc-merge -o tmpdemo2  rubydemo rails && test -d tmpdemo2
    CHECK_RESULT $? 0 0 "Check sdoc-merge -o failed"
    sdoc-merge -o tmp5 --names "Rubyxxx,Railsxxx"  rubydemo rails && test -d ./tmp5/Rubyxxx && test -d ./tmp5/Railsxxx
    CHECK_RESULT $? 0 0 "Check sdoc-merge --names failed"
    sdoc-merge -o tmp6 -n "Rubyxxx,Railsxxx"  rubydemo rails && test -d ./tmp6/Rubyxxx && test -d ./tmp6/Railsxxx
    CHECK_RESULT $? 0 0 "Check sdoc-merge -n failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./mergedata/ ./common/*.rb ./common/*.sh
    LOG_INFO "End to restore the test environment."
}

main "$@"
