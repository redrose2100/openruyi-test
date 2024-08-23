#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-08-23
# @License   :   Mulan PSL v2
# @Desc      :   test nl-link-list
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    nl-link-list
    CHECK_RESULT $? 0 0 "nl-link-list execute fail"
    nl-link-list --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "nl-link-list --help execute fail"
    nl-link-list --version | grep -i libnl
    CHECK_RESULT $? 0 0 "nl-link-list --version execute fail"
    nl-link-list --details | grep index
    CHECK_RESULT $? 0 0 "nl-link-list --details execute fail"
    nl-link-list --stats | grep index
    CHECK_RESULT $? 0 0 "nl-link-list --stats execute fail"
    link_name=$(nl-link-list --details | grep group | awk -F' ' 'NR==1 {print $1}')
    nl-link-list -n "${link_name}" | grep group
    CHECK_RESULT $? 0 0 "nl-link-list -n execute fail"
    nl-link-list -i 1 | grep group
    CHECK_RESULT $? 0 0 "nl-link-list -i execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
