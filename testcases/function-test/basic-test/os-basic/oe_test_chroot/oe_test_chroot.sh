#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-04-13
# @License   :   Mulan PSL v2
# @Desc      :   Use chroot case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pwd=`pwd`
    mkdir testroot && cd testroot
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir bin lib lib64
    CHECK_RESULT $? 0 0 "Error,fail to create 'bin' & 'lib' & 'lib64'"
    cp /bin/bash bin/
    CHECK_RESULT $? 0 0 "Error,fail to copy /bin/bash to bin/"
    cp -r /lib/* lib/
    CHECK_RESULT $? 0 0 "Error,fail to copy /lib/ to lib/"
    cp -r /lib64/* lib64/
    CHECK_RESULT $? 0 0 "Error,fail to copy /lib64/ to lib64/"
    cd .. && chroot testroot /bin/bash -c "pwd" | grep /
    CHECK_RESULT $? 0 0 "Error,Failed to modify permissions "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $pwd && rm -rf testroot/
    LOG_INFO "End to restore the test environment."
}

main "$@"