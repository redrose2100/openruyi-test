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
    lsdiff -# 1 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -# 1 test2.patch  failed"
    lsdiff --hunks=1 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --hunks=1 test2.patch  failed"
    lsdiff -F 1 --lines=-5 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -F 1 --lines=-5 test2.patch  failed"
    lsdiff --files=1 --lines=-5 test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --files=1 --lines=-5 test2.patch  failed"
    lsdiff -z 1.txt.gz
    CHECK_RESULT $? 0 0 "Check lsdiff -z 1.txt.gz  failed"
    lsdiff --decompress 1.txt.gz
    CHECK_RESULT $? 0 0 "Check lsdiff --decompress 1.txt.gz  failed"
    lsdiff -n -N -H test2.patch | grep "test2.patch:1"
    CHECK_RESULT $? 0 0 "Check lsdiff -n -N -H test2.patch  failed"
    lsdiff --line-number --number-files --with-filename test2.patch | grep "test2.patch:1"
    CHECK_RESULT $? 0 0 "Check lsdiff --line-number --number-files --with-filename test2.patch  failed"
    lsdiff -h test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff -h test2.patch  failed"
    lsdiff --no-filename test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check lsdiff --no-filename test2.patch  failed"
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
