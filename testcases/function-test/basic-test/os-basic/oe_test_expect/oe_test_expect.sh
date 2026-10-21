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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023.3.2
# @License   :   Mulan PSL v2
# @Desc      :   Expect basic function verification
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "expect"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa |grep expect
    CHECK_RESULT $? 0 0 "expect install failed"
    expect -v | grep version
    CHECK_RESULT $? 0 0 "expected version query failed"
    remoteip="${NODE2_IPV4}"
    remotepw="${NODE2_PASSWORD}"
    cat > test.sh << EOF
#!/usr/bin/expect
spawn ssh -o "StrictHostKeyChecking no" root@$remoteip df -Th
expect "*password"
send "${remotepw}\n"
expect eof
EOF
    expect test.sh
    CHECK_RESULT $? 0 0 "execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.sh
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@