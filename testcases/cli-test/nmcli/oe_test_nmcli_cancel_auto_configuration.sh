#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/03/29
# @License   :   Mulan PSL v2
# @Desc      :   nmcli cancel auto configuration 
# #############################################

source "../common/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    echo "[main]
dns=none" >/etc/NetworkManager/conf.d/90-dns-none.conf
    rm -rf /etc/resolv.conf
    systemctl reload NetworkManager
    CHECK_RESULT $? 0 0 "reload failure"
    test -f /etc/resolv.conf
    CHECK_RESULT $? 0 1 "configure failure"
    rm -rf /etc/NetworkManager/conf.d/90-dns-none.conf
    systemctl reload NetworkManager
    CHECK_RESULT $? 0 0 "reload failure"
    test -f /etc/resolv.conf
    CHECK_RESULT $? 0 0 "generate failure"
    rm -rf /etc/resolv.conf
    echo "## test" >/etc/resolv.conf.manually-configured
    ln -s /etc/resolv.conf.manually-configured /etc/resolv.conf
    cat /etc/resolv.conf | grep '## test'
    CHECK_RESULT $? 0 0 "link failure"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /etc/resolv.conf /etc/resolv.conf.manually-configured
    systemctl reload NetworkManager
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

