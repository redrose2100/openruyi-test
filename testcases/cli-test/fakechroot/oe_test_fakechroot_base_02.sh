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
# @Desc      :   verify the uasge of fakechroot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL fakechroot
    cp ./common/hello.sh ./
    chmod 777 hello.sh
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so -e idd.fakechroot ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l -e failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so --environment idd.fakechroot ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l --environment failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so -c /etc/fakechroot ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l -c failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so --config-dir /etc/fakechroot ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l --config-dir failed"

    fakechroot -b ./fakechroot -l /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -b -l failed"

    fakechroot --bindir ./fakechroot -l /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot --bindir -l  failed"

    fakechroot -- ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -- failed"

    ldd.fakechroot /bin/cat | grep "libc.so"
    CHECK_RESULT $? 0 0 "Check ldd.fakechroot failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf hello.sh
    LOG_INFO "Finish restore the test environment."
}

main "$@"
