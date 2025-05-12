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
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-12-21
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test umount fs when file is opened
#####################################

source "${OET_PATH}/testcases/system-test/fs-test/common_lib/fsio_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL lvm2
    IFS=' ' read -ra fs_args <<< "$FS_TYPE"
    read -ra point_list <<< "$(CREATE_FS "${fs_args[@]}")"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        echo "test" > "$var/testFile"
        nohup vi "$var/testFile" &
        umount "$var"
        CHECK_RESULT $? 0 0 "Umount fs $var failed."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS "${point_list[@]}"
    rm -f ./nohup.out
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

