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

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    lsdiff -p 1 -i '*.txt' test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -p 1 -i '*.txt' test2.patch  failed"
    lsdiff --strip-match=1 -i '*.txt' test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --strip-match=1 -i '*.txt' test2.patch  failed"
    lsdiff --strip=1 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --strip=1 test2.patch  failed"
    lsdiff --addprefix=1 test2.patch | grep "12.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --addprefix=1 test2.patch  failed"
    lsdiff --addoldprefix=1 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --addoldprefix=1 test2.patch  failed"
    lsdiff --addnewprefix=1 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --addnewprefix=1 test2.patch  failed"
    lsdiff -s test2.patch | grep "! 2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -s test2.patch  failed"
    lsdiff --status test2.patch | grep "! 2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --status test2.patch  failed"
    lsdiff -v test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -v test2.patch  failed"
    lsdiff --verbose test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --verbose test2.patch  failed"
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
