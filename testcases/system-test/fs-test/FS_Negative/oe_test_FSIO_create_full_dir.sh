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
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-01-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Inject full dir on fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS))
    DNF_INSTALL sysstat
    pwd=$(pwd)
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        cd $mnt_point
        top -d 2 >$mnt_point/cpu.log &
        iostat -d 2 >$mnt_point/iostat.log &
        start_time=$(date +%s)
        max_name_len=$(getconf NAME_MAX $mnt_point)
        i=0
        while [[ "$?" =~ "0" ]]; do
            dirName=$(GET_RANDOMNAME $max_name_len)
            i=$(($i + 1))
            mkdir $dirName
            if [[ "$?" =~ "1" ]]; then
                break
            fi
            cd $dirName
        done
        while [[ $i -gt 0 ]]; do
            first=$(ls -A | head -n 1)
            if [[ $first != "lost+found" ]]; then
                rm -rf $first
                cd ..
            fi
            i=$(($i - 1))
        done
        [ "$(pwd)" == "/mnt" ]
        CHECK_RESULT $? 0 "Check pwd failed."
        SLEEP_WAIT 10
        end_time=$(date +%s)
        exec_time=$(expr $(($end_time - $start_time)))
        LOG_INFO "Execute time is "$exec_time
        CHECK_BKG_MONITOR $mnt_point "85.0" "2500.00"
        CHECK_RESULT $? 0
        cd $pwd
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    DNF_REMOVE 0 sysstat
    LOG_INFO "End to restore the test environment."
}

main "$@"

