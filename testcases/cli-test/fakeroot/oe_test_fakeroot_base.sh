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
# @Desc      :   verify the uasge of fakeroot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL fakeroot
    echo 'echo "hello world"' >hello.sh
    chmod 777 hello.sh
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    fakeroot -l /usr/lib64/libfakeroot/libfakeroot-0.so -s hello -u ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot -l -s -u failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so -s hello --unknown-is-real ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib -s --unknown-is-real failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so ./hello.sh -f --foreground --unknown-is-real 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib -f --port --save-file --foreground --debug --load --unknown-is-real failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so -i hello --unknown-is-real ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib -i --unknown-is-real failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so ./hello.sh --faked --foreground --unknown-is-real 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib --faked --port --save-file --foreground --debug --load --unknown-is-real failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so -b --unknown-is-real ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib -b --unknown-is-real failed"

    fakeroot --lib /usr/lib64/libfakeroot/libfakeroot-0.so --fd-base --unknown-is-real ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot --lib --fd-base --unknown-is-real failed"

    fakeroot -l /usr/lib64/libfakeroot/libfakeroot-0.so -- ./hello.sh 2>&1 | grep "hello world"
    CHECK_RESULT $? 0 0 "Check fakeroot -l -- failed"

    fakeroot -h 2>&1 | grep "usage: fakeroot"
    CHECK_RESULT $? 0 0 "Check fakeroot -h failed"

    fakeroot --help 2>&1 | grep "usage: fakeroot"
    CHECK_RESULT $? 0 0 "Check fakeroot --help failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf hello.sh hello
    LOG_INFO "Finish restore the test environment."
}

main "$@"
