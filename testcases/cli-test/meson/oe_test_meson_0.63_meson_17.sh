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
    tar -xvf common/0.63/wrap-git.tgz&&cd ./"81 wrap-git"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson subprojects checkout --types git
    CHECK_RESULT $? 0 0 "meson-subprojects-chekout --types TYPES failed"
    meson subprojects update --num-processes 2
    CHECK_RESULT $? 0 0 "meson-subprojects-checkout --num-processes NUM_PROCESSES failed"
    meson subprojects download --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-download --help failed"
    meson subprojects download -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-download -h failed"
    meson subprojects download --sourcedir ./
    CHECK_RESULT $? 0 0 "meson-subprojects-download --sourcedir SOURCEDIR failed"
    meson subprojects download --types git
    CHECK_RESULT $? 0 0 "meson-subprojects-download --types TYPES failed"
    meson subprojects download --num-processes 2
    CHECK_RESULT $? 0 0 "meson-subprojects-download --num-processes NUM_PROCESSES failed"
    meson subprojects foreach --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-foreach --help failed"
    meson subprojects foreach -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-foreach -h failed"
    meson subprojects foreach download --sourcedir ./
    CHECK_RESULT $? 0 0 "meson-subprojects-foreach --sourcedir SOURCEDIR failed"
    meson subprojects foreach checkout --types git
    CHECK_RESULT $? 0 0 "meson-subprojects-foreach --types TYPES failed"
    meson subprojects foreach update --num-processes 2
    CHECK_RESULT $? 0 0 "meson-subprojects-foreach --num-processes NUM_PROCESSES failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./../"81 wrap-git"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"