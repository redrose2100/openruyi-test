#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023.1.31
# @License   :   Mulan PSL v2
# @Desc      :   libesmtp
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "libesmtp-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    gcc -std=c99 -Wall `libesmtp-config --cflags` -o sendmail $OET_PATH/testcases/cli-test/libesmtp/sendmail.c -lesmtp
    CHECK_RESULT $? 0 0  "c file failed to compile"
    echo "test" > test-mail.eml
    systemctl start postfix
    ./sendmail
    CHECK_RESULT $? 0 0  "The MTA cannot manage email"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf  $OET_PATH/testcases/cli-test/libesmtp/test-mail.eml $OET_PATH/testcases/smoke-test/cli-test/libesmtp/sendmail
    LOG_INFO "Finish environment cleanup!"
}

main $@
