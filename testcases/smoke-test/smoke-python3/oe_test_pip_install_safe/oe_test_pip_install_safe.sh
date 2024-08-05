#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   xieshouhang
# @Contact   :   1069178568@qq.com
# @Date      :   2024/08/05
# @Desc      :   user identity authentication sm test
# ##################################
# shellcheck disable=SC2002,SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which pip3 || yum install -y python3-pip
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    pip3 install --help | grep "extra-index-url"
    CHECK_RESULT $? 0 0 
    pip3 install --extra-index-url="http://test" > tmp_log 2>&1
    cat tmp_log | grep "WARNING: When the --extra-index-url"
    CHECK_RESULT $? 0 0 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y python3-pip" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "$id"
    rm -fr tmp_log
    LOG_INFO "End to clean the test environment."
}

main "$@"
