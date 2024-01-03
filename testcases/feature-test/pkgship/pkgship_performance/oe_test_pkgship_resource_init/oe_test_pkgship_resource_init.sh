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
#@Date      	:   2023-02-20
#@License   	:   Mulan PSL v2
#@Desc      	:   Check init performance
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
 
    ACT_SERVICE
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    start_time=$(date +%s)
    pkgship init -filepath ../../common_lib/openEuler_fedora.yaml
    end_time=$(date +%s)
    exec_time=$(("$end_time"-"$start_time"))
    LOG_INFO "Exectue init cmd for times: ""$exec_time"

    if [[ $exec_time -gt 420 ]]; then 
        CHECK_RESULT 1 0 0 "The init time is more than 4min."
    fi

    ls -a /opt/pkgship/tmp > tmp_file
    tmp=$(wc -l tmp_file | awk '{print $1}')
    if [[ $tmp -ne 2 ]]; then 
        CHECK_RESULT 1 0 0 "The init temp file doesn't delete."
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV
    rm -rf tmp_file

    LOG_INFO "End to restore the test environment."
}

main "$@"
