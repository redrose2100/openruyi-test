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
# @Desc      :   libcap-ng卸载安装测试
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    rpm -q libcap-ng || yum install libcap-ng -y
}

function run_test() {
    rpm -ql libcap-ng > libcap-ng_file 2>&1
    rpm -e libcap-ng --nodeps
    while read -r line; do
        test -f "$line"
        CHECK_RESULT $? 0 1
    done < libcap-ng_file

    yum install libcap-ng -y
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -rf libcap-ng_file
}

main "$@"
