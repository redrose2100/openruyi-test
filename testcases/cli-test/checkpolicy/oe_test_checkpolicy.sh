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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-12
# @License   :   Mulan PSL v2
# @Desc      :   checkpolicy basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "checkpolicy policycoreutils selinux-policy-*"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.te << EOF
module test 1.0;

require {
  type unconfined_t;
  type user_home_t;
  class file { read write };
}

allow unconfined_t user_home_t:file { read write };
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    checkmodule -M -m -o test.mod test.te
    CHECK_RESULT $? 0 0 "Command execution failed"
    test -f test.mod
    CHECK_RESULT $? 0 0 "File generation failed"
    semodule_package -o test.pp -m test.mod
    CHECK_RESULT $? 0 0 "Command execution failed"
    test -f test.pp
    CHECK_RESULT $? 0 0 "File generation failed"
    semodule -i test.pp
    CHECK_RESULT $? 0 0 "Install failed"
    semodule -l | grep test
    CHECK_RESULT $? 0 0 "Command execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    semodule -r test
    rm -rf test.mod test.pp test.te
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
