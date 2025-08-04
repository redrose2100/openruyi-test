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
# @Desc      :   Test multiruby_setup
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-ZenTest tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    multigem
    test ! -d  ~/.multiruby/tmp && mkdir ~/.multiruby/tmp
    cp ./data/svn.tag.cache ~/.multiruby/tmp 
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    if ! command -v multiruby_setup &> /dev/null; then
        echo "multiruby_setup command not found, skipping..."
        exit 255
    fi
    multiruby_setup -h | grep "usage: multiruby_setup"
    CHECK_RESULT $? 0 0 "Check multiruby_setup -h failed"
    multiruby_setup --help | grep "usage: multiruby_setup"
    CHECK_RESULT $? 0 0 "Check multiruby_setup --help failed"
    multiruby_setup build
    CHECK_RESULT $? 0 0 "Check multiruby_setup build failed"
    multiruby_setup clean
    CHECK_RESULT $? 0 0 "Check multiruby_setup clean failed"
    multiruby_setup list | grep "Known versions"
    CHECK_RESULT $? 0 0 "Check multiruby_setup list failed"
    multiruby_setup rm:v1_1c0
    CHECK_RESULT $? 0 0 "Check multiruby_setup rm failed"
    multiruby_setup tags
    CHECK_RESULT $? 0 0 "Check multiruby_setup tags failed"
    multiruby_setup rubygems:merge
    CHECK_RESULT $? 0 0 "Check multiruby_setup rubygems:merge failed"
    multiruby_setup update:rubygems the_usual
    CHECK_RESULT $? 0 0 "Check multiruby_setup update:rubygems failed"
    multiruby_setup update the_usual
    CHECK_RESULT $? 0 0 "Check multiruby_setup update failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf lib/ data/ ~/.multiruby
    LOG_INFO "End to restore the test environment."
}
main "$@"
