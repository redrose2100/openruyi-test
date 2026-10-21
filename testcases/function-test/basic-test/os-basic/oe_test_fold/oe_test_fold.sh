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
# @Date      :   2023-05-15
# @License   :   Mulan PSL v2
# @Desc      :   Use fold case
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
    cat > testfile << EOF
Linux networks are becoming more and more common, but 
security is often an overlooked  
issue. Unfortunately, in today’s environment all networks 
are potential hacker targets,  
EOF
    fold --help | grep "Usage: fold"
    CHECK_RESULT $? 0 0 "please check fold language"
    fold -w 30 testfile
    CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
    fold -b testfile 
    CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
    fold -c testfile 
    CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
    fold -s testfile 
    CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
    fold --version | grep "GNU coreutils"
    CHECK_RESULT $? 0 0 "No such file or directory"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf testfile
    LOG_INFO "End to clean the test environment."
}

main "$@"
