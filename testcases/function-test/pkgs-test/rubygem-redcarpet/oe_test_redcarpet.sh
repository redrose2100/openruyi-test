#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test redcarpet
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-redcarpet tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    redcarpet -h | grep "Usage: redcarpet"
    CHECK_RESULT $? 0 0 "Check redcarpet -h failed"
    redcarpet --help | grep "Usage: redcarpet"
    CHECK_RESULT $? 0 0 "Check redcarpet --help failed"
    redcarpet -v | grep -e "Redcarpet [0-9].*"
    CHECK_RESULT $? 0 0 "Check redcarpet -v failed"
    redcarpet --version | grep -e "Redcarpet [0-9].*"
    CHECK_RESULT $? 0 0 "Check redcarpet --version failed"
    redcarpet ./data/demo.md | grep "<li>thing one</li>"
    CHECK_RESULT $? 0 0 "Check redcarpet file failed"
    redcarpet --smarty ./data/demosmart.md | grep "<p>I&rsquo;ve been meaning to tell you ..</p>"
    CHECK_RESULT $? 0 0 "Check redcarpet --smarty failed"
    redcarpet --parse highlight ./data/demoparse.md  | grep "<mark>"
    CHECK_RESULT $? 0 0 "Check redcarpet --parse failed"
    redcarpet --render no-links ./data/demoparse.md | grep -e "\[link]"
    CHECK_RESULT $? 0 0 "Check redcarpet --render failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}
main "$@"
