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
#@Author        :   yuyi
#@Contact       :   1140934993@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson wrap
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson wrap --help | grep "usage: meson wrap"
    CHECK_RESULT $? 0 0 "meson wrap --help failed"
    meson wrap -h | grep "usage: meson wrap"
    CHECK_RESULT $? 0 0 "meson wrap -h failed"
    meson wrap list --help | grep "usage: meson wrap list"
    CHECK_RESULT $? 0 0 "meson wrap list --help failed"
    meson wrap list -h | grep "usage: meson wrap list"
    CHECK_RESULT $? 0 0 "meson wrap list -h failed"
    meson wrap search --help | grep "usage: meson wrap search"
    CHECK_RESULT $? 0 0 "meson wrap search --help failed"
    meson wrap search -h | grep "usage: meson wrap search"
    CHECK_RESULT $? 0 0 "meson wrap search -h failed"
    meson wrap install --help | grep "usage: meson wrap install"
    CHECK_RESULT $? 0 0 "meson wrap install --help failed"
    meson wrap install -h | grep "usage: meson wrap install"
    CHECK_RESULT $? 0 0 "meson wrap install -h failed"
    meson wrap update --help | grep "usage: meson wrap update"
    CHECK_RESULT $? 0 0 "meson wrap update --help failed"
    meson wrap update -h | grep "usage: meson wrap update"
    CHECK_RESULT $? 0 0 "meson wrap update -h failed"
    meson wrap info --help | grep "usage: meson wrap info"
    CHECK_RESULT $? 0 0 "meson wrap info --help failed"
    meson wrap info -h | grep "usage: meson wrap info"
    CHECK_RESULT $? 0 0 "meson wrap info -h failed"
    meson wrap status --help | grep "usage: meson wrap status"
    CHECK_RESULT $? 0 0 "meson wrap status --help failed"
    meson wrap status -h | grep "usage: meson wrap status"
    CHECK_RESULT $? 0 0 "meson wrap status -h failed"
    meson wrap promote --help | grep "usage: meson wrap promote"
    CHECK_RESULT $? 0 0 "meson wrap promote --help failed"
    meson wrap promote -h | grep "usage: meson wrap promote"
    CHECK_RESULT $? 0 0 "meson wrap promote -h failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"