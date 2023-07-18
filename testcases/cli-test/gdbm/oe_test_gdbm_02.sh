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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/07.14
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-gdbm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/test_gdbm
}

function run_test() {
    gdbmtool -n /tmp/test_gdbm/test.gdbm >/tmp/test_gdbm/gdbm.log1 <<-EOF
list
set
quit
EOF
    grep "blocksize is unset" /tmp/test_gdbm/gdbm.log1
    CHECK_RESULT $? 0 0 "The default configuration parameters fail to be displayed"
    gdbmtool >/tmp/test_gdbm/gdbm.log2 <<-EOF
store test_gdb get_value_success
quit
EOF
    gdbmtool >/tmp/test_gdbm/gdbm.log3 <<-EOF
fetch test_gdb
quit
EOF
    grep "get_value_success" /tmp/test_gdbm/gdbm.log3
    CHECK_RESULT $? 0 0 "get value fail"
    gdbmtool >/tmp/test_gdbm/gdbm.log4 <<-EOF
delete test_gdb
fetch test_gdb
quit
EOF
    grep "get_value_success" /tmp/test_gdbm/gdbm.log4
    CHECK_RESULT $? 0 1 "delete value fail"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_gdbm
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
