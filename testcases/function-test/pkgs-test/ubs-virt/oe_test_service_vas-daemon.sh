#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test vas-daemon.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "ubs-virt-awaresched libvirt"
    systemctl start libvirtd
    SLEEP_WAIT 5
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution vas-daemon.service
    test_reload vas-daemon.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop vas-daemon
    systemctl stop libvirtd
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
