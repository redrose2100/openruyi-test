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
# @Desc      :   Test mdmonitor.service restart
# #############################################

source "../common/common_lib.sh"
source "./common/common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL mdadm
    check_free_disk
    version=$(rpm -qa | grep mdadm | awk -F '-' '{print $2}')
    if version_ge $version 4.2 ;then
        echo "$version is greater than or equal to 4.2"
        echo -e "n\ne\n\n\n+5G\nn\nl\n\n\nw\n" | fdisk /dev/${local_disk}
        echo -e "t\n\nfd\nw\n" | fdisk /dev/${local_disk}
        echo -e "n\ne\n\n\n+5G\nn\nl\n\n\nw\n" | fdisk /dev/${local_disk1}
        echo -e "t\n\nfd\nw\n" | fdisk /dev/${local_disk1}
        mdadm -Cv /dev/md0 -l5 -n2 /dev/${local_disk}5 /dev/${local_disk1}5
        mdadm -D /dev/md0 | grep /dev/${local_disk}5 
        CHECK_RESULT $? 0 0 "check mdadm state failed"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution mdmonitor.service
    test_reload mdmonitor.service 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    if version_ge $version 4.2 ;then
       mdadm -S /dev/md0
       #cat /dev/null > /etc/mdadm.conf
       mdadm --zero-superblock /dev/${local_disk}5
       mdadm --zero-superblock /dev/${local_disk1}5
       echo -e "d\n1\nw\n" | fdisk "/dev/${local_disk}"
       echo -e "d\n1\nw\n" | fdisk "/dev/${local_disk1}"
    fi
    systemctl stop mdmonitor.service
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"