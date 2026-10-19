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
#@Author    	:   Li,Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Check init performance
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
 
    DNF_INSTALL sysstat
    ACT_SERVICE
    INIT_CONF../../common_lib/openEuler.yaml

    LOG_INFO "Finish to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    nohup top -d 2 -b >./top.log 2>&1 &
    nohup iostat -d 2 >./iostat.log 2>&1 &
    nohup vmstat 2 20 >./vmstat.log 2>&1 &
    pkgship selfdepend glibc -dbs -s -w >/dev/null
    
    top_pid=$(pgrep -f "top")
    iostat_pid=$(pgrep -f "iostat")
    vmstat_pid=$(pgrep -f "vmstat")
    kill -9 "$top_pid" "$iostat_pid" "$vmstat_pid"

    free_cpu=$(grep "Cpu" top.log | awk '{print $8}')
    read_io=$(grep '[0-9][0-9]' iostat.log | awk '{print $3}')
    vmstat_io=$(grep '[0-9][0-9]' vmstat.log | awk '{print $4}')

    for var in "${free_cpu[@]}"; do
        [[ $var -lt 50 ]] &&{
            CHECK_RESULT 1 0 0 "CPU is used with exception."
        }
    done

    for var in "${read_io[@]}"; do
        [[ $var -gt 100 ]] &&{
            CHECK_RESULT 1 0 0 "IO is used with exception."
        }
    done

    for var in "${vmstat_io[@]}"; do
        [[ $var -lt 28393664 ]] &&{
            CHECK_RESULT 1 0 0 "CPU is used with exception."
        }
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    DNF_REMOVE
    REVERT_ENV
    rm -rf iostat.log vmstat.log top.log

    LOG_INFO "End to restore the test environment."
}

main "$@"
