#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test slapd.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openldap-servers cyrus-sasl
    rpm -e --nodeps cyrus-sasl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl start slapd.service
    systemctl is-active slapd.service | grep -w "active"
    CHECK_RESULT $? 0 0 "slapd.service is not running"
    test -f "/etc/openldap/slapd.d/cn=config.ldif"
    CHECK_RESULT $? 0 0 "Config file cn=config.ldif not found"
    systemctl restart slapd.service
    CHECK_RESULT $? 0 0 "slapd.service restart failed"
    journalctl -u slapd --no-pager | grep -i error
    CHECK_RESULT $? 1 0 "Found errors in slapd logs"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop slapd.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
