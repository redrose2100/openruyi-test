#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangmengke
# @Contact   :   wangmengke@uniontech.com
# @Date      :   2024-7-11
# @License   :   Mulan PSL v2
# @Desc      :   Fincore
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    for i in {1..30}; do echo "Line $i" >> myfile.txt; done
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    more +6 myfile.txt | grep -i "Line 6"
    CHECK_RESULT $? 0 0 "more +6 is failed!"
    more +20 myfile.txt | grep -i "Line 20"
    CHECK_RESULT $? 0 0 "more +20 is failed!"  
    more +30 myfile.txt | grep -i "Line 30"
    CHECK_RESULT $? 0 0 "more +30 is failed!"     
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    rm -rf myfile.txt
    LOG_INFO "start environment cleanup!"
}

main "$@"