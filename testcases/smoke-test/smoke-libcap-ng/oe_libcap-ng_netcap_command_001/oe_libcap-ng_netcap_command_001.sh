#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   验证netcap参数
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    which netcap || DNF_INSTALL "libcap-ng libcap-ng-utils"
}

function run_test() {
    netcap | grep -E "tcp|udp|raw|pkt"
    CHECK_RESULT $? 0 0
}

function post_test() {
    DNF_REMOVE "$@"
}

main "$@"
