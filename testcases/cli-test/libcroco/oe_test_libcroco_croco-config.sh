#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/10/19
# @License   :   Mulan PSL v2
# @Desc      :   TEST croco-config
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    CROCO_CONFIG="croco-0.6-config"
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libcroco-devel"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    ${CROCO_CONFIG} --help | grep "Usage: croco-config"
    CHECK_RESULT $? 0 0 "option: --help error"
    ${CROCO_CONFIG} --version | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "option: --version error"
    ${CROCO_CONFIG} --libs | grep "lglib-2.0 -lxml2"
    CHECK_RESULT $? 0 0 "option: --libs error"
    ${CROCO_CONFIG} --cflags | grep "@GLIB2_CFLAGS@ @LIBXML2_CFLAGS@"
    CHECK_RESULT $? 0 0 "option: --cflags error"
    ${CROCO_CONFIG} --prefix | grep "/usr"
    CHECK_RESULT $? 0 0 "option: --prefix [default /usr] error"
    ${CROCO_CONFIG} --exec-prefix | grep "/usr"
    CHECK_RESULT $? 0 0 "option: --exec-prefix [default /usr] error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"