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
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023/04/11
# @License   :   Mulan PSL v2
# @Desc      :   cifs模块加载、卸载
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    modinfo cifs |grep cifs
    CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
    lsmod | grep  cifs
    CHECK_RESULT $? 0 1 "Default installation"
    modprobe cifs
    CHECK_RESULT $? 0 0 "Module loading failure"
    lsmod | grep  cifs
    CHECK_RESULT $? 0 0 "vport_geneve not found"
    rmmod  cifs
    CHECK_RESULT $? 0 0 "vport-geneve remove failure"
    lsmod | grep  cifs
    CHECK_RESULT $? 0 1 "vport_geneve exist"
    dmesg | grep "vport_geneve" | grep -Ei 'error|fail'
    CHECK_RESULT $? 1 0 "error message was reported"
}

main "$@"

