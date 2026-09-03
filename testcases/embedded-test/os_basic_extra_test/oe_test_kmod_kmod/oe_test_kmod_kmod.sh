#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2020/10/29
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of kmod command
# ############################################

# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    kmod -h | grep -E "Usage:|kmod \[options\]"
    CHECK_RESULT $?
    kmod -V | grep -i "kmod version"
    CHECK_RESULT $?
    kmod help | grep -E "Usage:|help \[options\]"
    CHECK_RESULT $?
    kmod list | grep "[a-zA-Z0-9]"
    CHECK_RESULT $?
    if ! kmod static-nodes | grep -E "Module|Device node"; then
        kmod static-nodes
        CHECK_RESULT $?
        ls /dev/full
        CHECK_RESULT $?
        find /dev/ -name 'fu*' | wc -l | grep -v "^0$"
        CHECK_RESULT $?
    fi
    LOG_INFO "End of the test."
}

main "$@"
