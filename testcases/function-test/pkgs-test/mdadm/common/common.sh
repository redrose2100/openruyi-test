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
# 选盘与防护逻辑统一收敛到 libs/locallibs/disk_select_lib.sh。
# 本文件保留原路径与原文件名，并继续提供与磁盘无关的 version_ge()。
source "${OET_PATH}/libs/locallibs/disk_select_lib.sh"

function version_ge() { 
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}
