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
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/1/21
# @License   :   Mulan PSL v2
# @Desc      :   Test iftop text mode
# #############################################
#shellcheck disable=SC2034

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    EXECUTE_T="60m"
    DNF_INSTALL "iftop bind-utils ipcalc"
    IFS=' ' read -r -a net_cards <<< "$(TEST_NIC 1)"
    ipv4_addr_1=$(nmcli device show "${net_cards[0]}" | grep IP4.ADDRESS | awk '{print $2}' | cut -d '/' -f1)
    ipv4_addr_2=$(nmcli device show "${net_cards[1]}" | grep IP4.ADDRESS | awk '{print $2}' | cut -d '/' -f1)
    ipv4_target_addr=$(host huawei.com | grep 'has address' | awk '{print $4}')
    ipv4_target_hostname="hwclouds-dns"
    #qemu下获取默认路由所用的网络接口
    if [ "$(systemd-detect-virt)" = "qemu" ]; then
        INTERFACE=$(ip route show default | awk '{print $5}' | head -n1)
        iftop_cmd="iftop -i $INTERFACE"
    else 
        iftop_cmd="iftop"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    iftop -h | grep 'Synopsis: iftop'
    CHECK_RESULT $? 0 0 "Failed to use option: -h"
    ping "$ipv4_target_addr" -c 100 >/dev/null 2>&1 &
    $iftop_cmd -t -s 1 2>&1 | grep 'Listening on'
    pkill -f 'ping'
    CHECK_RESULT $? 0 0 "Failed to use option: -s and -t"
    ping "$ipv4_target_addr" -c 100 >/dev/null 2>&1 &
    SLEEP_WAIT 1
    dns_resolution_work=1
    for ((i = 0; i < 100; i++)); do
        SLEEP_WAIT 1
        if $iftop_cmd -t -s 1 2>&1 | grep "$ipv4_target_hostname"; then
            dns_resolution_work=0
            break
        fi
    done
    pkill -f 'ping'
    if [ $dns_resolution_work -eq 0 ]; then
        ping "${ipv4_target_addr}" -c 100 >/dev/null 2>&1 &
        SLEEP_WAIT 1
        $iftop_cmd -t -s 1 -n 2>&1 | grep "$ipv4_target_hostname"
        CHECK_RESULT $? 0 1 "Failed to use option: -n"
    else
        LOG_WARN "DNS RESOLUTION NOT WORK."
    fi
    pkill -f 'ping'
    result=1
    for ((i = 0; i < 10; i++)); do
        SLEEP_WAIT 1
        if { P_SSH_CMD --node 2 --cmd "while true; do date; sleep 1; done" >/dev/null 2>&1 & } && iftop -t -s 1 -p | grep ":ssh"; then
            result=0
            break
        fi
    done
    CHECK_RESULT $result 0 0 "Failed to use option: -P"
    pkill -f "do date"
    result=1
    for ((i = 0; i < 10; i++)); do
        SLEEP_WAIT 1
        if { P_SSH_CMD --node 2 --cmd "while true; do date; sleep 1; done" >/dev/null 2>&1 & } && iftop -t -s 1 -P -N | grep ":22"; then
            result=0
            break
        fi
    done
    CHECK_RESULT $result 0 0 "Failed to use option: -N"
    pkill -f "do date"
    
    if [ "$(systemd-detect-virt)" != "qemu" ]; then
        result=1
        ping -I "${ipv4_addr_1}" "${ipv4_target_addr}" -c 100 > /dev/null 2>&1 &
        SLEEP_WAIT 1
        ping -I "${ipv4_addr_2}" "${ipv4_target_addr}" -c 100 > /dev/null 2>&1 &
        SLEEP_WAIT 1
        for ((i = 0; i < 10; i++)); do
            SLEEP_WAIT 1
            output=$($iftop_cmd -t -s 1 -n -p 2>&1)
            if (echo "${output}" | grep -A 1 "${ipv4_addr_1}" | grep "${ipv4_target_addr}") && (echo "${output}" | grep -A 1 "${ipv4_addr_2}" | grep "${ipv4_target_addr}"); then
                result=0
                break
            fi
        done
        CHECK_RESULT $result 0 0 "Failed to use option: -p"
        pkill -f 'ping'
    
        result=1
        ping -I "${ipv4_addr_1}" "${ipv4_target_addr}" -c 100 >/dev/null 2>&1 &
        SLEEP_WAIT 1
        for ((i = 0; i < 10; i++)); do
            SLEEP_WAIT 1
            if $iftop_cmd -t -s 1 -B -n 2>&1 | grep "${ipv4_addr_1}" | grep 'B'; then
                result=0
                break
            fi
        done
        CHECK_RESULT $result 0 0 "Failed to use option: -B"
        pkill -f 'ping'
        SLEEP_WAIT 1

        ping -I "${ipv4_addr_1}" "${ipv4_target_addr}" -c 100 >/dev/null 2>&1 &
        SLEEP_WAIT 1
        iftop -t -s 1 -i "${net_cards[0]}" 2>&1 | grep "Listening on ${net_cards[0]}"
        CHECK_RESULT $? 0 0 "Failed to use option: -i"
        pkill -f 'ping'
    else
        result=1
        ipv4_addr_3=$(nmcli device show "${net_cards[2]}" | grep IP4.ADDRESS | awk '{print $2}' | cut -d '/' -f1)
        ping -I "${ipv4_addr_3}" "${ipv4_target_addr}" -c 100 > /dev/null 2>&1 &
        SLEEP_WAIT 1
        for ((i = 0; i < 10; i++)); do
            SLEEP_WAIT 1
            output=$($iftop_cmd -t -s 1 -n -p 2>&1)
            if (echo "${output}" | grep -A 1 "${ipv4_addr_3}" | grep "${ipv4_target_addr}"); then
                result=0
                break
            fi
        done
        CHECK_RESULT $result 0 0 "Failed to use option: -p"
        pkill -f 'ping'

        result=1
        ping -I "${ipv4_addr_3}" "${ipv4_target_addr}" -c 100 >/dev/null 2>&1 &
        SLEEP_WAIT 1
        for ((i = 0; i < 10; i++)); do
            SLEEP_WAIT 1
            if $iftop_cmd -t -s 1 -B -n 2>&1 | grep "${ipv4_addr_3}" | grep 'B'; then
                result=0
                break
            fi
        done
        CHECK_RESULT $result 0 0 "Failed to use option: -B"
        pkill -f 'ping'
        SLEEP_WAIT 1

        ping -I "$INTERFACE" "${ipv4_target_addr}" -c 100 >/dev/null 2>&1 &
        SLEEP_WAIT 1
        $iftop_cmd -t -s 1 2>&1 | grep "Listening on $INTERFACE"
        CHECK_RESULT $? 0 0 "Failed to use option: -i"
        pkill -f 'ping'
    fi
    
    result=1
    for ((i = 0; i < 10; i++)); do
        SLEEP_WAIT 1
        if  { P_SSH_CMD --node 2 --cmd "while true; do date; sleep 1; done" >/dev/null 2>&1 & } && iftop -t -s 1 -P -N -f "dst port 22" 2>&1 | grep ":22"; then
            result=0
            break
        fi
    done
    CHECK_RESULT $result 0 0 "Failed to use option: -f"
    pkill -f "do date"
    
    $iftop_cmd -t -s 1 -m 10b 2>&1 | grep 'Listening on'
    CHECK_RESULT $? 0 0 "Failed to use option: -m"
    $iftop_cmd -t -s 5 -o 2s 2>&1 | grep '2s'
    CHECK_RESULT $? 0 0 "Failed to use option: -o 2s"
    $iftop_cmd -t -s 15 -o 10s 2>&1 | grep '10s'
    CHECK_RESULT $? 0 0 "Failed to use option: -o 10s"
    $iftop_cmd -t -s 45 -o 40s 2>&1 | grep '40s'
    CHECK_RESULT $? 0 0 "Failed to use option: -o 40s"
    $iftop_cmd -t -s 1 -o source 2>&1 | grep 'Listening on'
    CHECK_RESULT $? 0 0 "Failed to use option: -o source"
    $iftop_cmd -t -s 1 -o destination 2>&1 | grep 'Listening on'
    CHECK_RESULT $? 0 0 "Failed to use option: -o destination"
    $iftop_cmd -t -s 1 -L 5 2>&1 | grep 'Listening on'
    CHECK_RESULT $? 0 0 "Failed to use option: -L"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
