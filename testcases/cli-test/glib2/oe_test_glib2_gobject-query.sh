#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gobject-query command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test --help (only one help test)
    gobject-query --help 2>&1 | grep -i "Usage\|usage"
    CHECK_RESULT $? 0 0 "gobject-query --help check failed"
    # Test tree (print type tree)
    timeout 10 gobject-query tree | grep "GObject"
    CHECK_RESULT $? 0 0 "gobject-query tree check failed"
    # Test -r (specify root type)
    timeout 10 gobject-query tree -r GParam | grep "GParam"
    CHECK_RESULT $? 0 0 "gobject-query -r check failed"
    # Test froots (iterate over fundamental roots)
    timeout 10 gobject-query froots  | grep -E "void|GInterface|gchar|GParamChar"
    CHECK_RESULT $? 0 0 "gobject-query froots check failed"
    # Test -n
    timeout 10 gobject-query froots -n | grep "GParamChar"
    CHECK_RESULT $? 0 1 "gobject-query -n check failed"
    timeout 10 gobject-query froots -n | grep "GInterface"
    CHECK_RESULT $? 0 0 "gobject-query -n check failed"
    # Test -b (specify indent string)
    timeout 10 gobject-query tree  -b "|---" | grep "|---"
    CHECK_RESULT $? 0 0 "gobject-query -b check failed"
    # Test -i (specify incremental indent string)
    timeout 10 gobject-query froots -i "" | grep -E "│├GParamChar| \+GParamChar"
    CHECK_RESULT $? 0 0 "gobject-query -i check failed"
    # Test -s (specify line spacing)
    timeout 10 gobject-query tree -s 2 | grep "GObject"
    CHECK_RESULT $? 0 0 "gobject-query -s check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"