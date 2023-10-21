#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangtingting 
#@Contact       :   wangting199611@126.com 
#@Date          :   2023/10/12
#@License       :   Mulan PSL v2
#@Desc          :   oncn-bwm command line test public functions
####################################
# shellcheck disable=SC2116,SC2004,SC2143,SC2009,SC2002
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function deploy_client() {
    local remote_ip=${1}
    local time=${2}
    local bandwidth=${3}
    local port=${4}
    local path=${5}
    local file=${6}

    iperf3 -c "$remote_ip" -i 0.5 -t "$time" -f MBytes -b "$bandwidth"M -p "$port" --logfile "$file" &
    pid=$(echo $!)
    echo "$pid" > /sys/fs/cgroup/net_cls/"$path"/cgroup.procs
}

function wait_client_stop() {
    local port=${1}
    local time=${2}

    for ((i = 0; i < $time; i++)); do
        if [ ! "$(ps aux | grep -v grep | grep 'iperf3 -c' | grep "$port")" ]; then
            break
        else
            sleep 1
        fi
    done
}

function get_diff() {
    local x=${1}
    local y=${2}
    
    # shellcheck disable=SC2086
    diff=$(awk 'BEGIN{print '$x'-'$y'}' | sed 's/-//')
    if [ "$diff" != "" ]; then
        echo "$diff" | xargs printf "%.*f\n" 0
    else
        echo 20
    fi
}

function get_avg() {
    local file=${1}
    local head_row=${2}
    local tail_row=${3}

    cat "$file" | grep sec | grep -v sender | grep -v receiver | head -"$head_row" | tail -"$tail_row" | awk '{print $7}' | awk '{sum+=$1}END{print"", sum/NR}' | sed 's/ //g'
}

