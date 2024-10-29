#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   验证captest参数
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    which captest || DNF_INSTALL "libcap libcap-ng libcap-ng-utils"
}

function run_test() {
    #验证--drop-all参数
    captest --drop-all > drop_all_info 2>&1
    grep -E "^Current capabilities: none$" < drop_all_info && grep -E "Child capabilities: none$" < drop_all_info
    CHECK_RESULT $? 0 0

    #验证--drop-caps参数
    captest --drop-caps > drop_caps_info 2>&1
    grep -E "^Current capabilities: none$" < drop_caps_info && grep -E "^Child capabilities:$" < drop_caps_info
    CHECK_RESULT $? 0 0
    grep -E -A5 "^Child capabilities:$" < drop_caps_info && grep -E "^Effective:" < drop_caps_info
    CHECK_RESULT $? 0 0
    grep -E -A5 "^Child capabilities:$" < drop_caps_info && grep -E "^Permitted:" < drop_caps_info
    CHECK_RESULT $? 0 0
    grep -E -A5 "^Child capabilities:$" < drop_caps_info && grep -E "^Inheritable:" < drop_caps_info
    CHECK_RESULT $? 0 0
    grep -E -A5 "^Child capabilities:$" < drop_caps_info && grep -E "^Bounding Set:" < drop_caps_info
    CHECK_RESULT $? 0 0

    #验证--text参数
    captest --text > text_info 2>&1
    grep "^Child Effective:" < text_info
    CHECK_RESULT $? 0 0
    grep "^Child Permitted:" < text_info
    CHECK_RESULT $? 0 0
    grep "^Child Inheritable:" < text_info
    CHECK_RESULT $? 0 0
    grep "^Child Bounding Set:" < text_info
    CHECK_RESULT $? 0 0

}

function post_test() {
    rm -rf drop_all_info drop_caps_info text_info
    DNF_REMOVE "$@"
}

main "$@"
