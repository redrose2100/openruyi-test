#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #######################################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test test gdb recovery database 
# #######################################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gdbm
    mkdir /tmp/test
    cd /tmp/test
    gdbmtool -n test.gdbm <<EOF
store 1 "ut00001"
quit
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    gdbm_dump test.gdbm test.dump
    test -e test.dump
    CHECK_RESULT $? 0 0 "Generation failure 1"
    rm -f test.gdbm
    test -e test.gdbm
    CHECK_RESULT $? 0 1 "Delete failure"
    gdbm_load test.dump test123.gdbm
    test -e test123.gdbm
    CHECK_RESULT $? 0 0 "Generation failure 2"
    expect <<-END
    spawn gdbmtool test123.gdbm
    log_file log.txt
    expect "gdbmtool"
    send "l\\n"
    expect "gdbmtool"
    send "quit\\n"
    expect eof
    exit
END
    grep '1 ut00001' log.txt
    CHECK_RESULT $? 0 0 "Recovery failure"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
