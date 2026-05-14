#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   OpenCode
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify httpd rejects invalid configuration and recovers after restore
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL httpd
    conf_file=/etc/httpd/conf/httpd.conf
    backup_file=/tmp/httpd.conf.mugen.bak
    cp -f "${conf_file}" "${backup_file}"
    rm -rf httpd_invalid.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    apachectl -t >/dev/null 2>&1
    CHECK_RESULT $?
    systemctl restart httpd
    CHECK_RESULT $?
    systemctl is-active httpd | grep active
    CHECK_RESULT $?

    printf '\nInvalidDirective On\n' >>"${conf_file}"
    apachectl -t >httpd_invalid.log 2>&1
    CHECK_RESULT $? 0 1
    systemctl restart httpd >>httpd_invalid.log 2>&1
    CHECK_RESULT $? 0 1

    cp -f "${backup_file}" "${conf_file}"
    apachectl -t >/dev/null 2>&1
    CHECK_RESULT $?
    systemctl restart httpd
    CHECK_RESULT $?
    systemctl is-active httpd | grep active
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    test -f "${backup_file}" && cp -f "${backup_file}" "${conf_file}"
    systemctl stop httpd >/dev/null 2>&1
    rm -rf "${backup_file}" httpd_invalid.log
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
