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
# @Desc      :   TEST scsitape
# #############################################

source "common/common.sh"

# Data and parameter configuration to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    # Introduce common function
    common_config_params
    LOG_INFO "End to config params of the case."   
}

# Installation Preparation of test objects and tools required for test
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # Introduce common function
    common_pre
    common_load
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    common_test
    # Set the tape drive's SCSI block size to <n> bytes. (NOTE: if you are using your OS's native tape driver, THIS IS EVIL!).
    scsitape -f ${PATH_TAPE} setblk 5
    CHECK_RESULT $? 0 0 "option: -f setblk error"
    # Go forward by <n> tapemarks. 
    scsitape -f ${PATH_TAPE} fsf 0
    CHECK_RESULT $? 0 0 "option: -f fsf error"
    # Go to immediately previous the <n>th previous tapemark. (WARNING: This probably doesn't do what you expect -- e.g.
    scsitape -f ${PATH_TAPE} bsf 0
    CHECK_RESULT $? 0 0 "option: -f bsf error"
    # Go to end of data. 
    scsitape -f ${PATH_TAPE} eod
    CHECK_RESULT $? 0 0 "option: -f eod error"
    # Rewind the tape drive. 
    scsitape -f ${PATH_TAPE} rewind
    CHECK_RESULT $? 0 0 "option: -f rewind error"
    # write <n> filemarks ( 'mark 0' flushes the drive's buffers ).
    scsitape -f ${PATH_TAPE} mark 0
    CHECK_RESULT $? 0 0 "option: -f mark error"
    # Seek to a logical position <n> that was reported by a previous 'tapeinfo' command. 
    scsitape -f ${PATH_TAPE} seek 0
    CHECK_RESULT $? 0 0 "option: -f seek  error"
    # write blocks from stdin to the tape. Chunk the data into <blocksize>-sized chunks. *DOES NOT WRITE OUT A TAPEMARK!* (you will need to use a subsequent mark 1 command to write out a tape mark). 
    echo $'01AB.测试。\n' > scsitape -f ${PATH_TAPE} write 5 50
    CHECK_RESULT $? 0 0 "option: -f write  error"
    # read blocks from the tape, write them to stdout. If we are in variable block mode, <blocksize> should be zero
    scsitape -f ${PATH_TAPE} read 5 50
    CHECK_RESULT $? 0 0 "option: -f read  error"
    # Eject the tape currently in the drive. 
    scsitape -f ${PATH_TAPE} eject
    CHECK_RESULT $? 0 0 "option: -f eject  error"
    LOG_INFO "End to run test."
}

# Post processing and recovery of test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    # Introduce common function
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
