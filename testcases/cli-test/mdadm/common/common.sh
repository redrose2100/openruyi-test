#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   womery
# @Contact   :   yhwangej@isoftstone.com
# @Date      :   2023-03-08
# @License   :   Mulan PSL v2
# @Desc      :   free disk select and version compare
# ############################################
# shellcheck disable=SC2034,SC2086,SC2206,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function check_free_disk() {
    disks=$(TEST_DISK)
    disk_list=($disks)
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
}

function version_ge() { 
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}
