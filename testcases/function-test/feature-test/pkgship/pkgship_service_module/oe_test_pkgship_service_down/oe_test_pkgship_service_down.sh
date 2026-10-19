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
#@Desc      	:   Close pkgship service
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    ACT_SERVICE
    mv "${SYS_CONF_PATH}"/conf.yaml "${SYS_CONF_PATH}"/conf.yaml.bak
    cp -p ../../common_lib/openEuler.yaml "${SYS_CONF_PATH}"/conf.yaml
    ACT_SERVICE stop
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    pkgship init | grep "The pkgship service is not started,please start the service first"
    CHECK_RESULT $? 0 0 "Init db unexpectly while pkgship down."

    pkgship list openeuler  | grep "ERROR_CONTENT  :There seems to be a problem with the service"
    CHECK_RESULT $? 0 0 "Query list unexpectly while pkgship down."
    pkgship pkginfo git-daemon openeuler | grep "ERROR_CONTENT  :There seems to be a problem with the service"
    CHECK_RESULT $? 0 0 "Query pkginfo unexpectly while pkgship down."
    pkgship installdep Judy -level 1 | grep "ERROR_CONTENT  :Server error"
    CHECK_RESULT $? 0 0 "Query installdep unexpectly while pkgship down."
    pkgship builddep openEuler-repos | grep "ERROR_CONTENT  :Server error"
    CHECK_RESULT $? 0 0 "Query builddep unexpectly while pkgship down."
    pkgship selfdepend openEuler-repos | grep "ERROR_CONTENT  :Server error"
    CHECK_RESULT $? 0 0 "Query selfdepend unexpectly while pkgship down."
    pkgship bedepend openeuler openEuler-repos | grep "ERROR_CONTENT  :Server error"
    CHECK_RESULT $? 0 0 "Query bedepend unexpectly while pkgship down."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    mv "${SYS_CONF_PATH}"/conf.yaml.bak "${SYS_CONF_PATH}"/conf.yaml
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
