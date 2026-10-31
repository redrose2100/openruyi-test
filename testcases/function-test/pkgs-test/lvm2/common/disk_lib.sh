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
source ${OET_PATH}/libs/locallibs/common_lib.sh
# 选盘与防护逻辑统一收敛到 libs/locallibs/disk_select_lib.sh。
# 本文件保留原路径与原文件名，避免改动引用它的用例脚本 source 语句。
source "${OET_PATH}/libs/locallibs/disk_select_lib.sh"
