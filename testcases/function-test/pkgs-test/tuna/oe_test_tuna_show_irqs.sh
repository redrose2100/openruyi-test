#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/01/02
# @License   :   Mulan PSL v2
# @Desc      :   Test "tuna" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "tuna"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    tuna show_irqs -h | grep "usage: tuna show_irqs"
    CHECK_RESULT $? 0 0 "tuna show_irqs -h No Pass"
    tuna show_irqs --help | grep "usage: tuna show_irqs"
    CHECK_RESULT $? 0 0 "tuna show_irqs --help No Pass"
    tuna show_irqs -c 0 | grep "0"
    CHECK_RESULT $? 0 0 "tuna show_irqs -c No Pass"
    tuna show_irqs --cpus 0 | grep "0"
    CHECK_RESULT $? 0 0 "tuna show_irqs --cpus No Pass"
    tuna show_irqs -S 0 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "tuna show_irqs -S No Pass"
    tuna show_irqs --sockets 0 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "tuna show_irqs --sockets No Pass"
    tuna show_irqs -q pciehp | grep -E "pciehp|virtio"
    CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
    tuna show_irqs --irqs pciehp | grep -E "pciehp|virtio"
    CHECK_RESULT $? 0 0 "tuna show_irqs --irqs No Pass"
    tuna show_configs | grep "config"
    CHECK_RESULT $? 0 0 "tuna show_configs No Pass"
    tuna show_configs -h | grep "usage: tuna show_configs"
    CHECK_RESULT $? 0 0 "tuna show_configs -h No Pass"
    tuna show_configs --help | grep "usage: tuna show_configs"
    CHECK_RESULT $? 0 0 "tuna show_configs --help No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
