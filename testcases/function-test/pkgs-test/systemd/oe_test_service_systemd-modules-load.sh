#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test systemd-modules-load.service restart
# #############################################
# shellcheck disable=SC1091

source "../common/common_lib.sh"
    
function run_test() {
    LOG_INFO "systemd-modules-load.service is an early boot service that loads kernel modules based on static configuration."
    if dnf list --installed | grep multipath-tools; then
        echo "Start condition was met, Status of systemd-modules-load.service is active (exited)"
        exit 255
    fi
    LOG_INFO "Start testing..."
    test_oneshot systemd-modules-load.service 'inactive (dead)'
    LOG_INFO "Finish test!"
}

main "$@"
