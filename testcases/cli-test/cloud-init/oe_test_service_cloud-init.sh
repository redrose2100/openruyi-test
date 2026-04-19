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
# @Desc      :   Test cloud-init.service restart
# #############################################
# shellcheck disable=SC1091

source "../common/common_lib.sh"

function check_cloud_init_log() {
    if systemd-detect-virt 2>/dev/null | grep -Eq "qemu|kvm"; then
        LOG_INFO "Ignore expected cloud-init metadata probe timeouts in qemu/kvm."
        journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING" |
            grep -vE "url_helper\.py\[ERROR\]: Timed out, no response from urls: .*(169\.254\.169\.254|\[fe80::a9fe:a9fe\]|\[fd00:ec2::254\]|198\.18\.1\.87)"
    else
        journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    fi
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cloud-init
    service=cloud-init.service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    log_time="$(date '+%Y-%m-%d %T')"
    test_restart "${service}"
    test_enabled "${service}"
    check_cloud_init_log
    test_reload "${service}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    rm -rf /etc/ssh/sshd_config.d
    systemctl restart sshd
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
