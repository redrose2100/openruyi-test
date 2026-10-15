#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2026/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test rdma-hw.target restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "rdma-core"
    if ! lspci | grep -i -E "infiniband|rdma|mellanox|connectx|iwarp";then
        LOG_INFO "There is no RDMA device in this environment."
        exit 255
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution rdma-hw.target
    test_reload rdma-hw.target
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop rdma-hw.target
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
