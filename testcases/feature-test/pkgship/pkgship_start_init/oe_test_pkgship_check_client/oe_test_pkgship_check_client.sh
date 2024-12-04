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
#@Date      	:   2024-01-29
#@License   	:   Mulan PSL v2
#@Desc      	:   Set pkgship server and check by client
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/aarch64/x86_64/g" ./conf.yaml
    fi
    cp -p "${SYS_CONF_PATH}"/package.ini "${SYS_CONF_PATH}"/package.ini.bak
    sed -i "/^query_ip_addr/c query_ip_addr=${NODE2_IPV4}" "${SYS_CONF_PATH}"/package.ini

    DNF_INSTALL "pkgship" 2
    SSH_SCP "${SYS_CONF_PATH}/package.ini" "root@${NODE2_IPV4}:/etc/pkgship" "${NODE2_PASSWORD}"
    SSH_SCP "./conf.yaml" "root@${NODE2_IPV4}:/etc/pkgship" "${NODE2_PASSWORD}"
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "bash /etc/pkgship/auto_install_pkgship_requires.sh redis
             bash /etc/pkgship/auto_install_pkgship_requires.sh elasticsearch
             chown pkgshipuser:pkgshipuser /etc/pkgship/* 
             systemctl restart pkgship
             pkgship init
             systemctl stop firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Create pkgship server failed."
    pkgship -remote dbs | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship dbs -remote failed."
    pkgship -remote list openeuler-2009 | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship list openEuler -remote failed."
    pkgship -remote pkginfo Judy openeuler-2009 | grep Judy >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship pkginfo Judy openeuler -remote failed."
    pkgship -remote installdep Judy | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship installdep Judy -remote failed."
    pkgship -remote builddep Judy | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship builddep Judy -remote failed."
    pkgship -remote selfdepend Judy | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship selfdepend Judy -remote failed."
    pkgship -remote bedepend openeuler-2009 Judy | grep "openeuler-2009" >/dev/null
    CHECK_RESULT $? 0 0 "Check pkgship bedepend openeuler Judy -remote failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    mv -f "${SYS_CONF_PATH}"/package.ini.bak "${SYS_CONF_PATH}"/package.ini
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/x86_64/aarch64/g" ./conf.yaml
    fi
    REVERT_ENV
    SSH_CMD "systemctl stop pkgship
             dnf remove pkgship redis elasticsearch -y
             systemctl restart firewalld
             rm -rf /etc/pkgship
             ps -ef | egrep 'pkgship|uwsgi|elasticsearch|redis' | grep -v grep | awk '{print $2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
