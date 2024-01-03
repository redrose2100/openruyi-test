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
#@Desc      	:   Query and restart service
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
 
    ACT_SERVICE
    mv "${SYS_CONF_PATH}"/conf.yaml "${SYS_CONF_PATH}"/conf.yaml.bak
    cp -p ../../common_lib/openEuler.yaml "${SYS_CONF_PATH}"/conf.yaml
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    pkgship init &
    systemctl restart pkgship >/dev/null
    SLEEP_WAIT 5
    pkgship dbs 
    pkgship dbs | grep "ERROR_CONTENT  :Unable to get the generated database information"
    CHECK_RESULT $?

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ./result.txt "${SYS_CONF_PATH}"/conf.yaml 
    mv "${SYS_CONF_PATH}"/conf.yaml.bak "${SYS_CONF_PATH}"/conf.yaml
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
