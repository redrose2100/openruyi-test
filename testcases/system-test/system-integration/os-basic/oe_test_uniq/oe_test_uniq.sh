#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2023.8.10
# @License   :   Mulan PSL v2
# @Desc      :   Uniq formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch testfile_uniq
    cat > testfile_uniq << EOF
Hello
Hello
Hello
UOS
UOS
UOS
UOS
Linux
Linux
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    res1=$(uniq testfile_uniq|sed -n 1,1p)
    [ "$res1" == "Hello" ]
    CHECK_RESULT $? 0 0 "uniq error"
    res2=$(uniq testfile_uniq|sed -n 2,2p)
    [ "$res2" == "UOS" ]
    CHECK_RESULT $? 0 0 "uniq error"
    res3=$(uniq testfile_uniq|sed -n 3,3p)
    [ "$res3" == "Linux" ]
    CHECK_RESULT $? 0 0 "uniq error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_uniq
    LOG_INFO "End to restore the test environment."
}

main "$@"
