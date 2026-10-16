#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-pwd
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL grub2-common
    current_path=$(dirname "$0")
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /etc/kernel || exit 1
    pwd | grep "/etc/kernel"
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd "${current_path}" || exit 1
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
