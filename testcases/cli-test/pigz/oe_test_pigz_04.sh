#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/12.27
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-pigz
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/pigz
    touch /tmp/pigz/11.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    pigz -F /tmp/pigz/11.txt
    test -e /tmp/pigz/11.txt.gz
    CHECK_RESULT $? 0 0 "pigz -F command execution failure"
    mv /tmp/pigz/11.txt.gz  /tmp/pigz/file.zip
    pigz -H /tmp/pigz/file.zip
    CHECK_RESULT $? 0 0 "pigz -H command execution failure"
    pigz --list /tmp/pigz/file.zip.gz
    test -e /tmp/pigz/file.zip.gz
    CHECK_RESULT $? 0 0 "pigz --list command execution failure"
    mv /tmp/pigz/file.zip.gz  /tmp/pigz/file.zip
    pigz -m8 /tmp/pigz/file.zip
    test -e /tmp/pigz/file.zip.gz
    CHECK_RESULT $? 0 0 "pigz -m command execution failure"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/pigz
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

