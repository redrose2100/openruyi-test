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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Enable periodic block discard
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
# 选盘与防护逻辑统一收敛到 libs/locallibs/disk_select_lib.sh。
# 本文件保留原路径、原导出变量与末尾“source 即选盘”的行为，
# 因为本套件大部分用例没有显式调用 check_free_disk，依赖 source 时自动选盘。
source "${OET_PATH}/libs/locallibs/disk_select_lib.sh"
export local_disk
export local_disk1
export local_disk2
export local_disk3

check_free_disk "$@"
