#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/07/27
# @License   :   Mulan PSL v2
# @Desc      :   构造/var/run/sshd.init.pid文件异常，然后重启sshd服务正常
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

sshd_pid_dir1="/var/run/sshd.pid"
sshd_pid_dir2="/var/run/sshd.init.pid"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sshd
    CHECK_RESULT $? 0 0

}

function run_test() {
    LOG_INFO "Start to prepare the test environment."
    if test -f $sshd_pid_dir1; then
        echo > $sshd_pid_dir1
    else
        echo > $sshd_pid_dir2
    fi
    systemctl restart sshd
    CHECK_RESULT $? 0 0
    systemctl status sshd
    CHECK_RESULT $? 0 0
    pid=$(pgrep -f "/usr/sbin/sshd" | awk 'NR==1{print $2}')
    echo "${pid}"
    CHECK_RESULT $? 0 0
    if test -f $sshd_pid_dir1; then
        pid1=$(< $sshd_pid_dir1 awk '{print $1}' | head -n 1)
        echo "${pid1}"
    else
        pid1=$(< $sshd_pid_dir2 awk '{print $1}' | head -n 1)
        echo "${pid1}"
    fi
    if [ "${pid}" -ne "${pid1}" ]; then
        ((tmp_result++))
    fi
    if [ "$tmp_result" -eq 0 ]; then
        CHECK_RESULT $? 0 0
    fi
}

function post_test() {
    LOG_INFO "Nothing to do."
}

main "$@"
