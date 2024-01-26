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
#@Author    	:   Li,Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Test the execution time of pkgship selfdepend
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
 
    ACT_SERVICE
    cp -p "${SYS_CONF_PATH}"/conf.yaml "${SYS_CONF_PATH}"/conf.yaml.bak
    INIT_CONF ../../common_lib/openEuler.yaml
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    start_time=$(date +%s)
    pkgship selfdepend glibc >/dev/null
    end_time=$(date +%s)
    exec_time1=$(("$end_time" - "$start_time"))
    echo "Exectue first cmd for times: "$exec_time1

    start_time=$(date +%s)
    pkgship selfdepend glibc >/dev/null
    end_time=$(date +%s)
    exec_time2=$(("$end_time" - "$start_time"))
    echo "Exectue second cmd for times: "$exec_time2
    
    cp ../../common_lib/openEuler.yaml "${SYS_CONF_PATH}"/conf.yaml
    chown pkgshipuser:pkgshipuser "${SYS_CONF_PATH}"/conf.yaml
    pkgship init >/dev/null
    
    start_time=$(date +%s)
    pkgship selfdepend glibc >/dev/null
    end_time=$(date +%s)
    exec_time3=$(("$end_time" - "$start_time"))
    echo "Exectue third cmd for times: "$exec_time3

    if [[ $exec_time2 -le $exec_time1 && $exec_time2 -le $exec_time3 ]]; then 
        CHECK_RESULT 0 0 0 "Seconde query time less than first time."
    else 
        CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${SYS_CONF_PATH}"/conf.yaml
    mv "${SYS_CONF_PATH}"/conf.yaml.bak "${SYS_CONF_PATH}"/conf.yaml
    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
