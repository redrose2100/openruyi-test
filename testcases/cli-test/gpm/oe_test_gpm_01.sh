#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   1820463064@qq.com
# @Date      :   2025/10/11
# @License   :   Mulan PSL v2
# @Desc      :   Test gpm
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gpm
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution gpm.service    
    systemctl status gpm.service | grep -q "active (running)"
    CHECK_RESULT $? 0 0 "Check gpm.service basic status"
    systemctl list-dependencies gpm.service --plain | head -10
    CHECK_RESULT $? 0 0 "Check gpm.service dependencies"
    systemctl enable gpm.service
    CHECK_RESULT $? 0 0 "Enable gpm.service auto-start"
    systemctl is-enabled gpm.service | grep -q "enabled"
    CHECK_RESULT $? 0 0 "Verify gpm.service auto-start enabled"
    journalctl -u gpm.service --since="1 minute ago" --no-pager | head -5
    CHECK_RESULT $? 0 0 "Check gpm.service journal output"
    pgrep -f "gpm" > /dev/null
    CHECK_RESULT $? 0 0 "Check if gpm process is running"
    rpm -ql gpm | grep -E "(config|conf|service)" | head -5
    CHECK_RESULT $? 0 0 "Check gpm package configuration files"
    test -f /usr/lib/systemd/system/gpm.service
    CHECK_RESULT $? 0 0 "Check gpm.service unit file existence"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
     # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

