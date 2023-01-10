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
    diff -Naur 1.txt 2.txt >test1.patch
    diff -Naur 2.txt 3.txt >test2.patch
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    flipdiff --help 2>&1 | grep "usage: flipdiff"
    CHECK_RESULT $? 0 0 "Check flipdiff --help  failed"
    flipdiff --version | grep "flipdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check flipdiff --version  failed"
    flipdiff -U 10 -i -w -b -B -q test1.patch test2.patch | grep "@@ -2 +2,3 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff -U 10 -i -w -b -B -q test1.patch test2.patch  failed"
    flipdiff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch | grep "@@ -2 +2,3 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch  failed"
    flipdiff -p 1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff -p 1 test1.patch test2.patch  failed"
    flipdiff --strip-match=1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --strip-match=1 test1.patch test2.patch  failed"
    flipdiff -d 1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff -d 1 test1.patch test2.patch  failed"
    flipdiff --drop-context=1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --drop-context=1 test1.patch test2.patch  failed"
    flipdiff -z --interpolate test1.patch test2.patch | grep "\-bbb"
    CHECK_RESULT $? 0 0 "Check flipdiff -z --interpolate test1.patch test2.patch  failed"
    flipdiff --decompress --interpolate test1.patch test2.patch | grep "\-bbb"
    CHECK_RESULT $? 0 0 "Check flipdiff --decompress --interpolate test1.patch test2.patch  failed"
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
