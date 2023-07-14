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
    gdbmtool --help |grep Usage
    CHECK_RESULT $? 0 0 "Description Failed to query the help information"
    gdbmtool -n /tmp/test_gdbm/test.gdbm >/tmp/test_gdbm/creat_gdbm.log <<-EOF
list
status
quit
EOF
    test -f /tmp/test_gdbm/creat_gdbm.txt
    gdbmtool >/tmp/test_gdbm/controls_gdbm.log <<-EOF
status
open /tmp/test_gdbm/test.gdbm
status
close
status
quit
EOF
   num_1=$(grep -c "Database is not open" /tmp/test_gdbm/controls_gdbm.log)
   CHECK_RESULT "$num_1" 2 0 "num_1 Incorrect quantity"
   grep "Database is open" /tmp/test_gdbm/controls_gdbm.log
   CHECK_RESULT $? 0 0 "open test.gdbm fail"

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_gdbm
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
