#!/usr/bin/bash
  
# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangpeng
# @Contact   :   wangpengb@uniontech.com
# @Date      :   2022-07-29
# @License   :   Mulan PSL v2
# @Desc      :   smoke basic os test-diff
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "diffutils"
    echo "aaa" > ./diff_test1
    echo "aab" > ./diff_test2
    cp ./diff_test1 ./diff_test3
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    diff --version | grep "diff (GNU diffutils)"
    CHECK_RESULT $? 0 0 "-version error"
    diff -s diff_test1 diff_test3 | grep -E "identical|相同"
    CHECK_RESULT $? 0 0 "compare same file failed"
    diff diff_test1 diff_test2 > diff_test.log
    CHECK_RESULT $? 1 0 "compare diff file failed"
    grep "aaa" diff_test.log
    CHECK_RESULT $? 0 0 "compare diff file log error"
    LOG_INFO "Finish test!"
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./diff_test*
    LOG_INFO "Finish environment cleanup!"
}

main $@

