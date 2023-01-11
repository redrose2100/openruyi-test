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

    fakechroot -h 2>&1 | grep -Pz "Usage:[\S\s]*fakechroot"
    CHECK_RESULT $? 0 0 "Check fakechroot -h failed"

    fakechroot --help 2>&1 | grep -Pz "Usage:[\S\s]*fakechroot"
    CHECK_RESULT $? 0 0 "Check fakechroot --help failed"

    fakechroot --version | grep "fakechroot version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check fakechroot --version failed"

    fakechroot -v | grep "fakechroot version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check fakechroot -v failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l failed"

    fakechroot --lib /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot --lib failed"

    fakechroot -d /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -d failed"

    fakechroot --elfloader /usr/lib64/fakechroot/libfakechroot.so ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot --elfloader failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so -s ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l -s failed"

    fakechroot -l /usr/lib64/fakechroot/libfakechroot.so --use-system-libs ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check fakechroot -l --use-system-libs failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf hello.sh
    LOG_INFO "Finish restore the test environment."
}

main "$@"
