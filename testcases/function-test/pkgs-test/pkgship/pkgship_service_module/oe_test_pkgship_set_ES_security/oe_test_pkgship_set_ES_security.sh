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
#@Desc      	:   Set ES security
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
 
    ACT_SERVICE
    cp -p "${ES_CONF_PATH}"/elasticsearch.yml "${ES_CONF_PATH}"/elasticsearch.yml.bak
    INIT_CONF ../../common_lib/openEuler.yaml
    echo "xpack.security.enabled: true
xpack.license.self_generated.type: basic
xpack.security.transport.ssl.enabled: true" >>"${ES_CONF_PATH}"/elasticsearch.yml
    for i in $(pgrep -a -f "pkgship|uwsgi|elasticsearch|redis" | grep -Ev "nohup|mugen.sh|oe_test|grep" | awk '{print $1}'); do
        kill -9 "$i"
    done

    systemctl start elasticsearch.service
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    pkgship dbs | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query dbs unexpectly while ES sets security."
    pkgship list openeuler-lts | grep "ERROR_CONTENT "
    CHECK_RESULT $? 0 0 "Query list unexpectly while ES sets security."
    pkgship pkginfo git-daemon openeuler-lts | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query pkginfo unexpectly while ES sets security."
    pkgship installdep Judy -level 1 | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query installdep unexpectly while ES sets security."
    pkgship builddep openEuler-repos | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query builddep unexpectly while ES sets security."
    pkgship selfdepend openEuler-repos | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query selfdepend unexpectly while ES sets security."
    pkgship bedepend openeuler-lts openEuler-repos | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "Query bedepend unexpectly while ES sets security."

    ACT_SERVICE stop
    systemctl start pkgship
    journalctl -u pkgship -n 20 | grep "\[ERROR\] The ES you installed is set to access with a password and cannot be used."
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when set es security"
    su pkgshipuser -c "pkgshipd start 2>&1" | grep "\[ERROR\] The ES you installed is set to access with a password and cannot be used."
    CHECK_RESULT $? 0 0 "Check start by systemctl failed when set es security"
  

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${ES_CONF_PATH}"/elasticsearch.yml
    mv "${ES_CONF_PATH}"/elasticsearch.yml.bak "${ES_CONF_PATH}"/elasticsearch.yml
    systemctl stop elasticsearch.service
    REVERT_ENV
    LOG_INFO "End to restore the test environment."
}

main "$@"
