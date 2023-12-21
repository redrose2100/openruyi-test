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
#@Author    	:   limeiting
#@Contact       :   244349477@qq.com
#@Date      	:   2023-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Access of start service
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    mv "${SYS_CONF_PATH}"/conf.yaml "${SYS_CONF_PATH}"/conf.yaml.bak
    cp -p ../../common_lib/openEuler.yaml "${SYS_CONF_PATH}"/conf.yaml
    chown pkgshipuser:pkgshipuser "${SYS_CONF_PATH}"/conf.yaml
    useradd test_pkgship_user
    echo 'test_pkgship_user' | passwd --stdin test_pkgship_user

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship init | grep "Database initialize success"
    CHECK_RESULT $? 0 0 "Root init pkgship failed."
    su test_pkgship_user -c "pkgship init | grep 'The current user does not have initial execution permission'"
    CHECK_RESULT $? 0 0 "Normal user init pkgship succeed unexpectly."
    su pkgshipuser -c "pkgship init | grep 'Database initialize success'"
    CHECK_RESULT $? 0 0 "Admin pkgshipuser init pkgship failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    userdel test_pkgship_user
    rm -rf "${SYS_CONF_PATH}"/conf.yaml
    mv "${SYS_CONF_PATH}"/conf.yaml.bak "${SYS_CONF_PATH}"/conf.yaml
    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
