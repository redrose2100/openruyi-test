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
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/06/11
# @License   :   Mulan PSL v2
# @Desc      :   iputils从R11升级到R12后差异点检查：
#                废弃命令：ninfod、rarpd、rdisc
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    history_id=$(yum history | head -n3 | tail -n1 | awk '{print $1}')
    yum -y install iputils
}

function run_test() {
    LOG_INFO "Start to run test."
    #废弃命令 ninfod、rarpd、rdisc
    for cmd in ninfod rarpd rdisc; do
        if command -v "$cmd" > /dev/null 2>&1; then
            CHECK_RESULT $? 0 0 "Error: $cmd still exists in system."
            return 1
        fi
        if rpm -ql iputils | grep "$cmd".service > /dev/null 2>&1; then
            CHECK_RESULT $? 0 0 "Error: $cmd still exists in system."
            return 1
        fi
    done
    echo "ninfod、rarpd、rdisc has been abandoned."
}

function post_test() {
    yum -y history rollback "$history_id"
}

main "$@"




