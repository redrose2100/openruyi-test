#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023-05-29
# @License   :   Mulan PSL v2
# @Desc      :   Use csplit case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > /tmp/testfile << EOF
hello Linux!
Linux is a free Unix-type operating system.  
This is a Linux testfile!  
Linux
EOF
    csplit --help | grep "Usage: csplit"
    CHECK_RESULT $? 0 0 "please check csplit language"
    csplit /tmp/testfile 2 -f /tmp/xx
    CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
    grep "hello Linux!" /tmp/xx00
    CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
    grep "Linux is a free" /tmp/xx01
    CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf /tmp/testfile /tmp/xx00 /tmp/xx01
    LOG_INFO "End to clean the test environment."
}

main "$@"
