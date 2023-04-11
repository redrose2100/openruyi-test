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
# @Author    :   zhangmei
# @Contact   :   zhangmei@uniontech.com
# @Date      :   2023/04/11
# @License   :   Mulan PSL v2
# @Desc      :   softdog模块加载、卸载
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    modinfo softdog |grep softdog
    CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
    lsmod | grep  softdog
    CHECK_RESULT $? 0 1 "Default uninstallation"
    modprobe softdog
    CHECK_RESULT $? 0 0 "Module start"
    lsmod | grep  softdog
    CHECK_RESULT $? 0 0 "softdog found"
    rmmod  softdog
    CHECK_RESULT $? 0 0 "softdog remove failure"
    lsmod | grep  softdog
    CHECK_RESULT $? 0 1 "softdog stop"
    dmesg | grep "softdog" | grep -Ei 'error|fail'
    CHECK_RESULT $? 1 0 "error message was reported"
}

main "$@"
