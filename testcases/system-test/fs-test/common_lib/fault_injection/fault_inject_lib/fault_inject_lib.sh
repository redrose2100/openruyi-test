#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-01-14
#@License   	:   Mulan PSL v2
#@Desc      	:   common functions
#####################################

function CREATE_VG() {
    cur_date=$(date +%Y%m%d%H%M%S)
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    disk_name="/dev/"$free_disk
    if pvcreate "$disk_name" &>/dev/null; then
        vggroup="test_vggroup""$cur_date"
        vgcreate "$vggroup" "$disk_name" >/dev/null
    else
        vggroup=$(pvcreate "$disk_name" 2>&1 | grep "test_vggroup" | cut -d '"' -f 4)
    fi

    printf "%s" "$vggroup"
}

function CREATE_FS() {
    fs_type=${1-"ext3"}
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    msg=$vggroup" "
    lvname="test_lv""$count""$cur_date"
    lv=/dev/"$vggroup"/"$lvname"
    point="/mnt/point""$count""$cur_date"
    lvcreate -n "$lvname" -L 512M "$vggroup" -y >/dev/null
    mkfs -t "$fs_type" "$lv" >/dev/null
    mkdir "$point"
    mount "$lv" "$point" >/dev/null
    msg=$msg$point" "$lv
    echo "$msg"
}

function REMOVE_VG() {
    vggroup=$1
    [[ "$vggroup" -ne "" ]] && {
        vgremove "$vggroup" -y
    }

    mounted=$(df -T | grep "test_vggroup" | awk '{print $7}')
    if [[ "$mounted" -ne "" ]]; then
        for m in $mounted; do
            umount "$m"
        done
        vggroup=$(df -T | grep "test_vggroup" | awk '{print $1}' | cut -d '-' -f 1 | cut -d '/' -f 4 | head -n 1)
        vgremove "$vggroup" -yf
    fi

    if lsblk | grep "test_vggroup" >/dev/null; then
        vggroup=$(lsblk | grep "test_vggroup" | awk '{print $1}' | head -n 1 | cut -d '-' -f 1)
        vggroup=${vggroup:2}
        vgremove "$vggroup" -y
    fi
    rm -rf /mnt/point*
}

function GET_RANDOMNAME() {
    exp_len=$1
    j=0
    name=""
    for i in {a..z}; do
        ranList[$j]=$i
        j=$((j + 1))
    done
    for i in {A..Z}; do
        ranList[$j]=$i
        j=$((j + 1))
    done
    for i in {0..9}; do
        ranList[$j]=$i
        j=$((j + 1))
    done

    for i in $(seq 1 "$exp_len"); do
        index=$((RANDOM % j))
        name=$name${ranList[$index]}
    done

    printf "%s" "$name"
}

function CONCURRENCY_THREAD() {
    # $1: execution cmd
    # $2: execution time, default is 100
    start_time=$(date +%s)
    command=$1
    concurrency_num=${2-"100"}

    # Create fifo and exec
    [ -e /tmp/fd1 ] || mkfifo /tmp/fd1
    exec 3<>/tmp/fd1
    rm -rf /tmp/fd1
    for ((i = 0; i < 9; i++)); do
        echo ""
    done >&3

    count=1
    for j in $(seq 0 "$concurrency_num"); do
        read -r -u3
        {
            "$command" "$count" &>/dev/null
            sleep 5
            echo "" >&3

        } &
        count=$((count + 1))
    done

    wait
    end_time=$(date +%s)
    exec_time=$((end_time - start_time))
    echo "Exectue $concurrency_num cmd for times: ""$exec_time"

    exec 3>&-
    exec 3<&-
}

function echoText() {
    text=$1
    color=${2-"black"}
    if [ "$color" == "red" ]; then
        echo -e "\e[1;31m${text} \e[0m"
    elif [ "$color" == "green" ]; then
        echo -e "\e[1;32m${text} \e[0m"
    elif [ "$color" == "yellow" ]; then
        echo -e "\e[1;33m${text} \e[0m"
    else
        echo "$text"
    fi
}

function main() {
    func_name=$1
    param_list=$2
    if [ "$func_name"x != "inject"x ] && [ "$func_name"x != "show"x ] && [ "$func_name"x != "query"x ] && [ "$func_name"x != "clean"x ]; then
        echoText "The opearation type doesn't exist, please check!" "red"
        exit 1
    fi

    if [[ "$func_name"x == "inject"x ]]; then
        inject "$param_list"
    elif [[ "$func_name"x == "clean"x ]]; then
        clean "$param_list"
    elif [[ "$func_name"x == "query"x ]]; then
        query "$param_list"
    elif [[ "$func_name"x == "show"x ]]; then
        show
    else
        echoText "The opearation type doesn't exist, please check!" "red"
        exit 1
    fi
}
