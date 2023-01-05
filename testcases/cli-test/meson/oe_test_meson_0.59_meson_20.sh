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
    meson subprojects purge --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --help failed"
    meson subprojects purge -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-subprojects-purge -h failed"
    meson subprojects purge --sourcedir ./
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --sourcedir SOURCEDIR failed"
    meson subprojects purge --types git
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --types TYPES failed"
    meson subprojects purge --num-processes 2
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --num-processes NUM_PROCESSES failed"
    meson subprojects purge --include-cache
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --include-cache failed"
    meson subprojects purge --confirm
    CHECK_RESULT $? 0 0 "meson-subprojects-purge --confirm failed"
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