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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of scrub command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL scrub
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    scrub --version | grep "scrub version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check scrub --version failed"

    scrub -v | grep "scrub version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check scrub -v failed"

    timeout -s SIGKILL 2s scrub -b 102400 -X -s 1024K empty
    test -f ./empty/scrub.000
    CHECK_RESULT $? 0 0 "Check scrub -b -X -s failed"

    timeout -s SIGKILL 2s scrub --blocksize=102400 --device-size=1024K --freespace empty1
    test -f ./empty1/scrub.000
    CHECK_RESULT $? 0 0 "Check scrub --blocksize --device-size --freespace failed"

    echo "hello world" > a.txt
    scrub -p dod a.txt | grep "scrub: using DoD"
    CHECK_RESULT $? 0 0 "Check scrub p failed"

    echo "hello world" > b.txt
    scrub --pattern=dod b.txt | grep "scrub: using DoD"
    CHECK_RESULT $? 0 0 "Check scrub --pattern failed"

    echo "hello world" > t1.txt
    scrub t1.txt
    scrub t1.txt 2>&1 | fgrep "scrub: t1.txt already scrubbed? (-f to force)"
    CHECK_RESULT $? 0 0 "Check scrub failed"
    scrub -f t1.txt && grep -a "SCRUBBED" t1.txt
    CHECK_RESULT $? 0 0 "Check scrub -f failed"

    echo "hello world" > t2.txt
    scrub t2.txt
    scrub t2.txt 2>&1 | fgrep "scrub: t2.txt already scrubbed? (-f to force)"
    CHECK_RESULT $? 0 0 "Check scrub failed"
    scrub --force t2.txt && grep -a "SCRUBBED" t2.txt
    CHECK_RESULT $? 0 0 "Check scrub --force failed"

    echo "hello world" > t.txt
    scrub -S -D 3.txt t.txt && grep -a "SCRUBBED" 3.txt
    CHECK_RESULT $? 1 0 "Check scrub -S -D failed"

    echo "hello world" > t.txt
    scrub --no-signature --dirent 4.txt t.txt && grep -a "SCRUBBED" 4.txt
    CHECK_RESULT $? 1 0 "Check scrub --no-signature --dirent failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf empty empyt1 *.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
