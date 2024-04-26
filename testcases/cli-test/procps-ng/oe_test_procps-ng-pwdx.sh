#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-14
# @License   :   Mulan PSL v2
# @Desc      :   Use procps-ng-pwdx case
# ############################################
# shellcheck disable=SC1090,SC2265,SC2086

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    DNF_INSTALL gcc
}

function run_test() {
    LOG_INFO "Start to run test."
    cat >test.c <<EOF
int main(void)
{
while(1);
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error, Fail to create test.c"
    gcc test.c -o procps_ng_test
    CHECK_RESULT $? 0 0 "Error,Check if gcc is installed ？"
    ./procps_ng_test &
    process_ids=$(pgrep -f procps_ng_test | tr '\n' ' ')
    pwdx ${process_ids}
    CHECK_RESULT $? 0 0 "Error, Failed to obtain directory"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.c procps_ng_test
    kill -9 ${process_ids}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
