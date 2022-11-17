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
    flipdiff --combine test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --combine test1.patch test2.patch  failed"
    flipdiff --flip test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --flip test1.patch test2.patch  failed"
    flipdiff --no-revert-omitted test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check flipdiff --no-revert-omitted test1.patch test2.patch  failed"
    flipdiff --in-place test1.patch test2.patch
    CHECK_RESULT $? 0 0 "Check flipdiff --in-place test1.patch test2.patch  failed"
    filterdiff --grep ... test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check filterdiff --grep ... test2.patch  failed"
    filterdiff -X pattren --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff -X pattren --lines=-5 test2.patch  failed"
    fixcvsdiff -p -b 1.csv && test -f ./1.csv.bak
    CHECK_RESULT $? 0 0 "Check fixcvsdiff -p -b --deep-brainwave-mode --recurse --compare 1.csv  failed"
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
