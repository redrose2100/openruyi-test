#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2025-6-26
#@License       :   Mulan PSL v2
#@Desc          :   Public class
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function deploy_env() {
    DNF_INSTALL "vdo"
    if lsmod | grep kvdo; then
        dd if=/dev/zero of=vdo_test_device bs=1M count=10240
        losetup /dev/loop0 vdo_test_device
        vdo create -n my_vdo_volume --device /dev/loop0
    else
        LOG_INFO "Kernel module kvdo not found"
        exit 255
    fi
}

function clear_env() {
    vdo remove -n my_vdo_volume
    losetup -d /dev/loop0
    rm vdo_test_device -f
    DNF_REMOVE "$@"
}
