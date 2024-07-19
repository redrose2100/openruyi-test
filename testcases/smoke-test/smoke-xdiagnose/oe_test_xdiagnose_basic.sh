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
# @Author    :   clay
# @Contact   :   clay4016@126.com
# @Date      :   2023/10/15
# @License   :   Mulan PSL v2
# @Desc      :   Test xdiagnose
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "xdiagnose"
    SLEEP_WAIT 60
    LOG_INFO "End environmental preparation."
}

function run_test() {
    LOG_INFO "Start testing..."
    stdbuf -oL xd_arpstormcheck -f 1 -i 1 -c 2 > checklog 2>&1
    grep "SIP.*TIP.*Freq" checklog
    CHECK_RESULT $? 0 0 "xd_arpstormcheck result err"

    stdbuf -oL xd_scsiiocount -d sda -i 1 -t 5 > checklog 2>&1
    grep -c sda checklog | grep -w 5
    CHECK_RESULT $? 0 0 "xd_scsiiocount result err"

    local_ip=$(ip route | head -1 | awk '{print $9}')
    stdbuf -oL xd_tcpskinfo -a "${local_ip}" -p 22 > checklog 2>&1
    grep skmem checklog
    CHECK_RESULT $? 0 0 "xd_tcpskinfo result err"

    stdbuf -oL xd_scsiiotrace -d 0:0:0:0 -e start > checklog 2>&1 &
    l_time=0
    while ((l_time<10)); do
        grep "0:0:0:0" checklog && break
	sleep 1
        ((l_time++))
    done
    pkill xd_scsiiotrace
    grep "0:0:0:0" checklog | grep start
    CHECK_RESULT $? 0 0 "xd_scsiiotrace result err"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf checklog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"