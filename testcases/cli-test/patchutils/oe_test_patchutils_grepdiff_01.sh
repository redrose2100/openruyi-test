# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of patchutils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL patchutils
    mkdir patchutils
    cd patchutils
    cp ../common/* ./
    diff -Naur 2.txt 3.txt >test2.patch
    gzip 1.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    grepdiff --help 2>&1 | grep "usage: grepdiff"
    CHECK_RESULT $? 0 0 "Check grepdiff --help  failed"
    grepdiff -h 2>&1 | grep "usage: grepdiff"
    CHECK_RESULT $? 0 0 "Check grepdiff -h  failed"
    grepdiff --version | grep "grepdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check grepdiff --version  failed"
    grepdiff -x '*.c' --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -x '*.c' --lines=-5 aaa test2.patch  failed"
    grepdiff --exclude='*.c' --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --exclude='*.c' --lines=-5 aaa test2.patch  failed"
    grepdiff -X pattren --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -X pattren --lines=-5 aaa test2.patch  failed"
    grepdiff --exclude-from-file=pattern --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --exclude-from-file=pattern --lines=-5 aaa test2.patch  failed"
    grepdiff -i '*.txt' --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -i '*.txt' --lines=-5 aaa test2.patch  failed"
    grepdiff --include='*.txt' --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --include='*.txt' --lines=-5 aaa test2.patch  failed"
    grepdiff -I pattren --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -I pattren --lines=-5 aaa test2.patch  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf patchutils
    LOG_INFO "Finish restore the test environment."
}

main "$@"
