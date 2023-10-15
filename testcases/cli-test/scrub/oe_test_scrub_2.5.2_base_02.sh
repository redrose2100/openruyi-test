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

    echo "hello world" > t.txt
    scrub -r t.txt && test -f t.txt
    CHECK_RESULT $? 1 0 "Check scrub -r failed"

    echo "hello world" > t.txt
    scrub --remove t.txt && test -f t.txt
    CHECK_RESULT $? 1 0 "Check scrub --remove failed"

    echo "hello world" > t.txt
    ln -s t.txt t1.txt
    scrub -L t1.txt
    grep "hello world" t.txt && grep "hello world" t1.txt
    CHECK_RESULT $? 0 0 "Check scrub -L failed"

    echo "hello world" > t2.txt
    ln -s t2.txt t3.txt
    scrub --no-link t3.txt
    grep "hello world" t2.txt && grep "hello world" t3.txt
    CHECK_RESULT $? 0 0 "Check scrub --no-link failed"

    echo "hello world" > t4.txt
    scrub -R -t -D 3.txt t4.txt && grep -a "SCRUBBED" 3.txt
    CHECK_RESULT $? 0 0 "Check scrub -R -t failed"

    echo "hello world" > t4.txt
    scrub --no-hwrand --no-threads -D 4.txt t4.txt && grep -a "SCRUBBED" 4.txt
    CHECK_RESULT $? 0 0 "Check scrub --no-hwrand --no-threads failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf *.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
