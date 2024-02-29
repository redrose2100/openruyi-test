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
#@Desc      	:   check touch and ls file in device_view/remote
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

    cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && touch  test2_{1..10000}.txt
    result=$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^-")
    while ((result<10000));do echo "$result" && sleep 1 && result=$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^-");done
    SSH_CMD "echo \`cd ${com_path}/merge_view/testfile_1w_2 && ls -l | grep -c \"^-\"\` > /test_01.txt"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    SSH_CMD "echo \`cd ${com_path}/device_view/local/testfile_1w_2 && ls -l | grep -c \"^-\"\` > /test_02.txt"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    scp_txt
    CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "touch_ls_002_001 fail"
    CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "touch_ls_002_002 fail"
    CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^-")" 10000 0 "touch_ls_002_003 fail"
    CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && ls -l | grep -c "^-")" 10000 0 "touch_ls_002_004 fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    clean_env

    LOG_INFO "End to restore the test environment."
}

main "$@"