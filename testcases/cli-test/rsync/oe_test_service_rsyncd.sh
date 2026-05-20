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
# @Desc      :   Test rsyncd.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rsync
    # 记录 rsyncd 服务的原始状态
    original_rsyncd_state=$(systemctl is-active rsyncd.service) || true
    if [[ "$original_rsyncd_state" != "active" ]]; then
        systemctl start rsyncd.service
    fi
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution rsyncd.service
    test_reload rsyncd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    #恢复服务原始状态
    if [[ "$original_rsyncd_state" != "active" ]]; then
        systemctl stop rsyncd.service
    fi
    # shellcheck disable=SC2119
    DNF_REMOVE
}

main "$@"
