#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   vport-geneve模块加载、卸载
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    modinfo vport-geneve | grep vermagic
    CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
    lsmod | grep ^vport_geneve
    CHECK_RESULT $? 0 1 "Default installation"
    modprobe vport-geneve
    CHECK_RESULT $? 0 0 "Module loading failure"
    lsmod | grep ^vport_geneve
    CHECK_RESULT $? 0 0 "vport_geneve not found"
    modprobe -r vport-geneve
    CHECK_RESULT $? 0 0 "vport-geneve remove failure"
    lsmod | grep ^vport_geneve
    CHECK_RESULT $? 0 1 "vport_geneve exist"
    dmesg | grep "vport_geneve" | grep -Ei 'error|fail'
    CHECK_RESULT $? 1 0 "error message was reported"
}

main "$@"

