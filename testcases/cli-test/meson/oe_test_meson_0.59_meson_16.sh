#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   liuzhaoda
#@Contact       :   1048074322@qq.com
#@Date          :   2022-09-5
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-subprojects
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.59/test_4.tgz&&cd test_4
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson subprojects --help 2>&1 | grep "usage: meson" && meson subprojects -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects -h or --help failed"
    meson subprojects update --help 2>&1 | grep "usage: meson"&&meson subprojects update -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-update -h or --help failed"
    meson subprojects update --rebase
    CHECK_RESULT $? 0 0 "meson-subprojects-update --rebase failed"
    meson subprojects update --reset
    CHECK_RESULT $? 0 0 "meson-subprojects-update --reset failed"
    meson subprojects update --sourcedir ./
    CHECK_RESULT $? 0 0 "meson-subprojects-update --sourcedir SOURCEDIR ./ failed"
    meson subprojects update --types git
    CHECK_RESULT $? 0 0 "meson-subprojects-update --types TYPES failed"
    meson subprojects update --num-processes 2
    CHECK_RESULT $? 0 0 "meson-subprojects-update --num-processes NUM_PROCESSES failed"
    meson subprojects checkout --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-checkout --help failed failed"
    meson subprojects checkout -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-checkout -h failed failed"
    meson subprojects checkout -b
    CHECK_RESULT $? 0 0 "meson-subprojects-checkout -b failed"
    meson subprojects checkout --sourcedir ./
    CHECK_RESULT $? 0 0 "meson-subprojects-checkout --sourcedir SOURCEDIR failed"
    LOG_INFO "Finish test!"

}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../test_4
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"