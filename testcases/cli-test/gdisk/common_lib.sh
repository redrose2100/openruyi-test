#!/usr/bin/bash

# Copyright (c) 2023. xFusion Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liyongqiang
# @Contact   :   liyongqiang@xfusion.com
# @Date      :   2023/10/23
# @License   :   Mulan PSL v2
# @Desc      :   common lib for gdisk test
# #############################################

function get_unused_disk() {
    disk_list=$(fdisk -l | grep "Disk /dev/" | grep -vE 'loop|mapper' | awk -F ' |:|：' '{print $2}')
    for disk in $disk_list; do
        if [ "$(lsblk | grep -c "${disk#/dev/}")" -eq 1 ]; then
            unused_disk=$disk
            break
        fi
    done
}

function create_partition() {
    partition_num=${1:-1}
    partition_size=${2:-5G}
    i=1
    while [ $i -le "$partition_num" ]; do
        expect <<-END
        spawn gdisk $unused_disk
        expect "*help):"
        send "n\r"
        expect {
            "*default*):"
            {
                send "\r"
                expect "First sector*"
                send "\r"
            }
            "First sector*"
            {
                send "\r"
            }
        }
        expect "Last sector*"
        send "+$partition_size\r"
        expect "Hex code or GUID*"
        send "\r"
        expect "*help):"
        send "p\r"
        expect "*help):"
        send "wq\r"
        expect "Do you want to proceed?*"
        send "Y\r"
        expect eof
        exit
END
    ((++i))
    done
}

function delete_partition() {
    partition_num=${1:-1}
    expect <<-END
    spawn gdisk $unused_disk
    expect "*help):"
    send "d\r"
    expect {
        "Partition number*):"
        {
            send "$partition_num\r"
            expect "*help):"
            send "wq\r"
        }
        "*help):"
        {
            send "wq\r"
        }
    }
    expect "Do you want to proceed?*"
    send "Y\r"
    expect eof
    exit
END
}
