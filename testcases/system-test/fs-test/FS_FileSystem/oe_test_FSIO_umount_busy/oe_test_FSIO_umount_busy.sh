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
#@Desc      	:   Take the test umount fs busy
#####################################

source ../../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS))
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        cp ./test.sh $var/test.sh
        bash $var/test.sh &
        SLEEP_WAIT 1
        umount $var 2>&1 | grep "target is busy"
        CHECK_RESULT $? 0 0 "Umount fs $var unexpectly."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    process=$(ps -ef | grep test.sh | awk '{print $2}')
    for i in $process; do
        kill $i
    done
    SLEEP_WAIT 5
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"

