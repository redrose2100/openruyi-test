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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    ACT_SERVICE
    mv "${SYS_CONF_PATH}"/conf.yaml "${SYS_CONF_PATH}"/conf.yaml.bak
    cp -p ../../common_lib/openEuler.yaml "${SYS_CONF_PATH}"/conf.yaml
    chown pkgshipuser:pkgshipuser "${SYS_CONF_PATH}"/conf.yaml
    ACT_SERVICE restart
    DNF_INSTALL sysstat

    LOG_INFO "End to prepare the test environment.."
}

function run_test() {
    LOG_INFO "Start to run test."

    for i in $(seq 1 10); do
        echo "- dbname: openeuler$i
        src_db_file: file:///etc/pkgship/repo/openEuler-20.03/src
        bin_db_file: file:///etc/pkgship/repo/openEuler-20.03/bin
        priority: $i" >>"${SYS_CONF_PATH}"/conf.yaml
    done

    start_time=$(date +%s)
    nohup top -d 2 -b >./top.log 2>&1 &
    nohup iostat -d 2 >./iostat.log 2>&1 &
    nohup vmstat 2 20 >./vmstat.log 2>&1 &
    pkgship init
    CHECK_RESULT $? 0 0 "pkgship init failed."

    end_time=$(date +%s)
    exec_time=$(("$end_time" - "$start_time"))
    LOG_INFO "The exectuion time is $exec_time"

    top_pid=$(pgrep -f "top" | awk '{print $1}')
    iostat_pid=$(pgrep -f "iostat" | awk '{print $1}')
    vmstat_pid=$(pgrep -f "vmstat" | awk '{print $1}')
    kill -9 "$top_pid" "$iostat_pid" "$vmstat_pid"

    free_cpu=$(grep "Cpu" top.log | awk '{print $8}')
    read_io=$(grep '[0-9][0-9]' iostat.log | awk '{print $3}')
    vmstat_io=$(grep '[0-9][0-9]' vmstat.log | awk '{print $4}')

    for var in "${free_cpu[@]}"; do
        [[ $var -lt 50 ]] && {
            CHECK_RESULT 1 0 0 "CPU is used with exception."
        }
    done

    for var in "${read_io[@]}"; do
        [[ $var -gt 100 ]] && {
            CHECK_RESULT 1 0 0 "IO is used with exception."
        }
    done

    for var in "${vmstat_io[@]}"; do
        [[ $var -lt 28393664 ]] && {
            CHECK_RESULT 1 0 0 "VMstat is used with exception."
        }
    done

    ls -a /opt/pkgship/tmp > file_num
    tmp_num=$(wc -l file_num | awk '{print $1}')
    CHECK_RESULT "$tmp_num" 2 0 "The init temp file doesn't delete."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    ACT_SERVICE STOP
    rm -rf top.log iostat.log vmstat.log "${SYS_CONF_PATH}"/conf.yaml file_num
    mv "${SYS_CONF_PATH}"/conf.yaml.bak "${SYS_CONF_PATH}"/conf.yaml
    DNF_REMOVE "$@"
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
