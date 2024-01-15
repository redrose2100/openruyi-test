#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fuyh2020
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2020-09-19
# @License   :   Mulan PSL v2
# @Desc      :   Command test lz4
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "lz4"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > lz4_test1 << EOF
testlz4 test1
EOF
    cat > lz4_test2 << EOF
testlz4 test2
EOF
    lz4 -m lz4_test1 lz4_test2
    CHECK_RESULT $? 0 0 "compress file error"
    ls lz4_test1.lz4
    CHECK_RESULT $? 0 0 "check compress -m file1 error"
    ls lz4_test2.lz4
    CHECK_RESULT $? 0 0 "check compresss -m file2 error"

    rm -rf lz4_test1
    lz4 -d -m lz4_test1.lz4
    ls lz4_test1
    CHECK_RESULT $? 0 0 "decompress file error"

    rm -rf lz4_test2.lz4
    lz4 --rm -m lz4_test2 
    ls lz4_test2.lz4
    CHECK_RESULT $? 0 0 "check --rm file1 compress error"
    ls lz4_test2.txt
    CHECK_RESULT $? 0 1 "check --rm file1 exist error"
    lz4 -h
    CHECK_RESULT $? 0 0 "view help msg error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf lz4_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
