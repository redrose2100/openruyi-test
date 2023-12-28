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
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   2023/12/27
# @License   :   Mulan PSL v2
# @Desc      :   Test znew function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    echo "Hello, world!" > /tmp/testfile.txt
    gzip -S .Z /tmp/testfile.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    znew /tmp/testfile.txt.Z
    CHECK_RESULT $? 0 0 "znew error1"
    gzip -d /tmp/testfile.txt.gz
    CHECK_RESULT $? 0 0 "znew error2"
    grep "Hello, world!" /tmp/testfile.txt
    CHECK_RESULT $? 0 0 "znew error3"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testfile*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
