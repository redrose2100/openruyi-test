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
    yum install -y python3-enchant
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.check('hello'));print(d.check('enchant'))" > tmp_log
    count=$(grep -c "True" tmp_log)
    CHECK_RESULT "$count" 2
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.check('helol'));print(d.check('enchnt'))" > tmp_log
    count=$(grep -c "False" tmp_log)
    CHECK_RESULT "$count" 2
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.suggest('enchnt'))" > tmp_log
    grep enchant tmp_log
    CHECK_RESULT $? 0 0
    grep entrench tmp_log
    CHECK_RESULT $? 0 0
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y python3-enchant" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "$id"
    rm -fr tmp_log
    LOG_INFO "End to clean the test environment."
}

main "$@"

