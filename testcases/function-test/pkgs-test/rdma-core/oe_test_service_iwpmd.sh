#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/09/28
# @License   :   Mulan PSL v2
# @Desc      :   Test iwpmd.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "iwpmd libibverbs-utils"
    if ! lspci | grep -i -E "infiniband|rdma|mellanox|connectx|iwarp";then
        LOG_INFO "There is no RDMA device in this environment."
        exit 255
    fi
    if ! ibv_devinfo | grep -i "transport" | grep -i "iw";then
        LOG_INFO "There is no iWarp device in this environment."
        exit 255
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution iwpmd.service
    test_reload iwpmd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop iwpmd.service
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
