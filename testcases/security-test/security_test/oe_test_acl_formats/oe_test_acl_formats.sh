#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/07/17
# @License   :   Mulan PSL v2
# @Desc      :   acl setfacl/chacl sets the difference between acl formats
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch testfileA testfileB
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    setfacl -m u::7,g::4,o::0 testfileA
    CHECK_RESULT $? 0 0 "setfacl failed to change permissions for testfileA"
    setfacl -m u::rwx,g::r,o::- testfileB
    CHECK_RESULT $? 0 0 "setfacl failed to change permissions for testfileB"
    getfacl testfileA testfileB > test.txt
    diff test.txt setfacl.txt
    CHECK_RESULT $? 0 0 "test.txt and setfacl.txt have different contents"
    chacl u::rw,g::r,o::r testfileA
    CHECK_RESULT $? 0 0 "chacl failed to change permissions for testfileA"
    chacl u::6,g::4,o::4 testfileB
    CHECK_RESULT $? 0 1 "chacl seccess to change permissions for testfileB"
    getfacl testfileA testfileB > test.txt
    diff test.txt chacl.txt
    CHECK_RESULT $? 0 0 "test.txt and chacl.txt have different contents"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.txt testfileA testfileB
    LOG_INFO "Een to restore the test environment."
}

main "$@"
