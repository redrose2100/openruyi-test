#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   sevenjj
#@Contact   	:   2461603862@qq.com
#@Date      	:   2023-07-03
#@License   	:   Mulan PSL v2
#@Desc      	:   check rename directory in device_view/remote
#####################################

source ../common_distributed.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	
    pre_env
	
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    set_var

    cd ${com_path}/device_view/${remoteIDa}/testfile_1w_2 && touch  test_{1..10000}.txt
    result=`cd ${com_path}/merge_view/testfile_1w_2 && ls -l | grep "^-" | wc -l`
    while (($result<10000));do echo $result && sleep 1 && result=`cd ${com_path}/merge_view/testfile_1w_2 && ls -l | grep "^-" | wc -l`;done
    cd ${com_path}/device_view/${remoteIDa} && rename testfile_1w_2 testfile_1w_002 *
    SSH_CMD "echo \`cd ${com_path}/merge_view && ls | grep testfile_1w_002 | wc -l\` > /test_01.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "echo \`cd ${com_path}/device_view/local && ls | grep testfile_1w_002 | wc -l\` > /test_02.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    scp_txt
    CHECK_RESULT "$(cat /test_01.txt)" 1 0 "rename_file_002_001 fail"
    CHECK_RESULT "$(cat /test_02.txt)" 1 0 "rename_file_002_002 fail"
    CHECK_RESULT "$(cd ${com_path}/merge_view && ls | grep testfile_1w_002 | wc -l)" 1 0 "rename_file_002_003 fail"
    CHECK_RESULT "$(cd ${com_path}/device_view/${remoteIDa} && ls | grep testfile_1w_002 | wc -l)" 1 0 "rename_file_002_004 fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    clean_env

    LOG_INFO "End to restore the test environment."
}

main "$@"