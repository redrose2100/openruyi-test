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
# @Author    :   wenjun
# @Contact   :   1009065695@qq.com
# @Date      :   2021/12/29
# @License   :   Mulan PSL v2
# @Desc      :   Test fence_virtd.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL fence-virt*
    firewall-cmd --permanent --zone=trusted --change-interface=virbr0
    cat <<EOF | sudo fence_virtd -c








y
EOF
    mkdir -p /etc/cluster
    touch /etc/cluster/fence_xvm.key
    chmod 0600 /etc/cluster/fence_xvm.key
    dd if=/dev/urandom bs=512 count=1 of=/etc/cluster/fence_xvm.key
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution fence_virtd.service
    test_reload fence_virtd.service
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop fence_virtd.service
    firewall-cmd --permanent --zone=trusted --remove-interface=virbr0
    rm -rf /etc/cluster
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
