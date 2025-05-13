#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   Classicriver
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2022.4.27
# @License   :   Mulan PSL v2
# @Desc      :   disk select
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
export local_disk
export local_disk1
export local_disk2
export local_disk3

function check_free_disk() {
    disks=$(TEST_DISK "$@")
    read -r -a disk_list <<< "$(echo "$disks" | tr ' ' '\n' | grep -v '^nbd' | tr '\n' ' ')"
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    local_disk2=${disk_list[2]}
    local_disk3=${disk_list[3]}
}

check_free_disk "$@"