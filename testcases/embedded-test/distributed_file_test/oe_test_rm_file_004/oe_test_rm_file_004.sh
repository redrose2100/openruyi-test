#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2024-02-05
#@License   	:   Mulan PSL v2
#@Desc      	:   check rm file in remote merge_view
#####################################
# shellcheck disable=SC1091,SC2154,SC2010
source ../common_distributed.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	
    pre_env
	
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    set_var

    SSH_CMD "cd ${com_path}/merge_view/testfile_1w_4 && touch test_{1..10000}.txt"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    SSH_CMD "cd ${com_path}/merge_view/testfile_1w_4 && rm -rf ./*"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && ls -l | grep -c "^-")" 0 0 "rm_file_004_001 fail"
    CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && ls -l | grep -c "^-")" 0 0 "rm_file_004_002 fail"
    SSH_CMD "echo \`cd ${com_path}/merge_view/testfile_1w_4 && ls -l | grep -c \"^-\"\` > /test_01.txt"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    SSH_CMD "echo \`cd ${com_path}/device_view/local/testfile_1w_4 && ls -l | grep -c \"^-\"\` > /test_02.txt"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    scp_txt
    CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_file_004_003 fail"
    CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_file_004_004 fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    clean_env

    LOG_INFO "End to restore the test environment."
}

main "$@"