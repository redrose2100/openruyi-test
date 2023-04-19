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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/04/18
# @License   :   Mulan PSL v2
# @Desc      :   sdiff basic functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    mkdir /tmp/test
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/test
    sdiff --version
    CHECK_RESULT $? 0 0 "sdiff cannot view version information"
    echo "aaa" > file1
cat > file2  << EOF
aaa
ccc
EOF
    CHECK_RESULT $? 0 0 "File creation failure"
    sdiff file1 file2 | grep '>'
    CHECK_RESULT $? 0 0 "sdiff cannot detect the difference between the two files"
    sdiff -s file1 file2 | sed -e 's#>[[:space:]]##g' -e 's/^[[:space:]]*//g' >diff.log
    CHECK_RESULT $? 0 0 "Description Failed to export diff.log"
    cat diff.log | grep "ccc"
    CHECK_RESULT $? 0 0 "There is no difference between the two files in diff.log"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/test
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

