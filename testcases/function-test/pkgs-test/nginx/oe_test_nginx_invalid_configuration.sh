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
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify nginx validates a baseline configuration, rejects an invalid directive, and recovers after restore
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL nginx
    conf_file=/etc/nginx/nginx.conf
    backup_file=/tmp/nginx.conf.mugen.bak
    cp -f "${conf_file}" "${backup_file}"
    rm -rf nginx_invalid.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # Verify the baseline configuration works before injecting an invalid directive.
    /usr/sbin/nginx -t >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "nginx -t should pass with the original configuration"

    printf '\ninvalid_directive on;\n' >>"${conf_file}"
    /usr/sbin/nginx -t >nginx_invalid.log 2>&1
    CHECK_RESULT $? 0 1 "nginx -t should fail after injecting an invalid directive"

    cp -f "${backup_file}" "${conf_file}"
    /usr/sbin/nginx -t >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "nginx -t should pass after restoring the original configuration"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    test -f "${backup_file}" && cp -f "${backup_file}" "${conf_file}"
    systemctl stop nginx >/dev/null 2>&1
    rm -rf "${backup_file}" nginx_invalid.log
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main "$@"
