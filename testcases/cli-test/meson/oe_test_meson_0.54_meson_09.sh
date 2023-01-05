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
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-introspect
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.54/test_1.tgz&&cd test_1/builddir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson introspect --test 2>&1 | grep ']'
    CHECK_RESULT $? 0 0 "meson-introspect --test failed"
    meson introspect --backend ninja 2>&1 | grep "No command specified"
    CHECK_RESULT $? 0 0 "meson-introspect --backend failed"
    meson introspect -a 2>&1 | grep 'protocol'
    CHECK_RESULT $? 0 0 "meson-introspect -a failed"
    meson introspect --all 2>&1 | grep 'protocol'
    CHECK_RESULT $? 0 0 "meson-introspect --all failed"
    meson introspect -i 2>&1 | grep "No command specified"
    CHECK_RESULT $? 0 0 "meson-introspect -i failed"
    meson introspect --indent 2>&1 | grep "No command specified"
    CHECK_RESULT $? 0 0 "meson-introspect --indent failed"
    meson introspect --force-object-output 2>&1 | grep '{}'
    CHECK_RESULT $? 0 0 "meson-introspect --force-object-output failed"
    meson introspect -f 2>&1 | grep '{}'
    CHECK_RESULT $? 0 0 "meson-introspect -f failed"
    LOG_INFO "Finish test!"
}

function post_test()
{  
    LOG_INFO "Start to restore the test environment."
    rm -rf ../../test_1
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"