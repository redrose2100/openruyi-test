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
# @Author    :   mishan
# @Contact   :   1421035908@qq.com
# @Date      :   2022/08/14
# @License   :   Mulan PSL v2
# @Desc      :   TEST scsieject
# #############################################

source "common/common.sh"

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    # Introduce common function
    common_config_params
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # Load the medium into the drive. When this command is issued to a CD/DVD drive and the tray is extended the tray will be retracted if the drive is capable of it.
    common_pre
    common_load
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    # Introduce common function
    common_test
    # Test all commands in TEST_OP
    scsieject -f ${PATH_TAPE} load
    CHECK_RESULT $? 0 0 "option: -f load error"
    # Start the device. Some devices require a start command after a media changer has loaded new media into the device. 
    scsieject -f ${PATH_TAPE} start
    CHECK_RESULT $? 0 0 "option: -f start error"
    # Lock the device. Locks the device so that the medium cannot be removed manually. 
    scsieject -f ${PATH_TAPE} lock
    CHECK_RESULT $? 0 0 "option: -f lock error"
    # Unlock the device. Unlocks the device so that the medium can be removed manually. 
    scsieject -f ${PATH_TAPE} unlock
    CHECK_RESULT $? 0 0 "option: -f unlock error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    # Introduce common function
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
