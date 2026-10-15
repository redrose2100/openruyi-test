#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Test cifs.idmap command - CIFS idmap upcall helper
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cifs-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test command_exists: Verify cifs.idmap command is available
    which cifs.idmap > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifs.idmap command not found"

    # Test -h: Show help
    cifs.idmap -h 2>&1 | grep -i "usage" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.idmap -h help missing"

    # Test -v: Show version
    cifs.idmap -v 2>&1 | grep -i "version" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.idmap -v version failed"

    # Test missing_key_serial: Return non-zero when key_serial not provided
    cifs.idmap 2>/dev/null > /dev/null
    CHECK_RESULT $? 1 0 "cifs.idmap without key_serial should fail"

    # Test -t_timeout: Parse -t timeout option (still fails without key_serial)
    cifs.idmap -t 5 2>/dev/null > /dev/null
    CHECK_RESULT $? 1 0 "cifs.idmap -t timeout without key_serial should fail"

    # Test invalid_option: Invalid option produces error
    cifs.idmap --invalid 2>&1 | grep -i "invalid\|unrecognized" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.idmap invalid option should fail"

    # Test config_file: Verify config file exists
    [ -f "/etc/request-key.d/cifs.idmap.conf" ]
    CHECK_RESULT $? 0 0 "cifs.idmap config file missing"

    # Test idmap_plugin: Verify idmap-plugin exists
    [ -L "/etc/cifs-utils/idmap-plugin" ] || [ -f "/etc/cifs-utils/idmap-plugin" ]
    CHECK_RESULT $? 0 0 "idmap-plugin config missing"

    # Test idmapwb_so: Verify idmapwb.so plugin exists
    [ -f "/usr/lib64/cifs-utils/idmapwb.so" ]
    CHECK_RESULT $? 0 0 "idmapwb.so plugin missing"

    # Test cifs_idmap_sss_so: Verify cifs_idmap_sss.so plugin exists
    [ -f "/usr/lib64/cifs-utils/cifs_idmap_sss.so" ]
    CHECK_RESULT $? 0 0 "cifs_idmap_sss.so plugin missing"

    # Test config_upcall_path: Verify config file contains correct upcall path
    grep -q "cifs.idmap" /etc/request-key.d/cifs.idmap.conf 2>/dev/null
    CHECK_RESULT $? 0 0 "cifs.idmap.conf missing upcall path"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
