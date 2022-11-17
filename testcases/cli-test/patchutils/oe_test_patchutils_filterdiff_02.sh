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
    filterdiff -# 1 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff -# 1 test2.patch  failed"
    filterdiff --hunks=1 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --hunks=1 test2.patch  failed"
    filterdiff -F 1 --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff -F 1 --lines=-5 test2.patch  failed"
    filterdiff --files=1 --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --files=1 --lines=-5 test2.patch  failed"
    filterdiff --annotate --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@ Hunk"
    CHECK_RESULT $? 0 0 "Check filterdiff --annotate --lines=-5 test2.patch  failed"
    filterdiff --as-numbered-lines=before --lines=-5 test2.patch | grep ":aaa"
    CHECK_RESULT $? 0 0 "Check filterdiff --as-numbered-lines=before --lines=-5 test2.patch  failed"
    filterdiff --format=context --lines=-5 test2.patch | grep "*** 1,2"
    CHECK_RESULT $? 0 0 "Check filterdiff --format=context --lines=-5 test2.patch  failed"
    filterdiff --remove-timestamps --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --remove-timestamps --lines=-5 test2.patch  failed"
    filterdiff --clean --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --clean --lines=-5 test2.patch  failed"
    filterdiff -z 1.txt.gz
    CHECK_RESULT $? 0 0 "Check filterdiff -z 1.txt.gz  failed"
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
