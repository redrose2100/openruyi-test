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
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-07-28
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../common/Hello.java .
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    jdb -help | grep -i "jdb <选项>\|<options>"
    CHECK_RESULT $? 0 0 "jdb -help failed"
    javac Hello.java
    CHECK_RESULT $? 0 0 "javac Hello.java failed"
    expect -c "
    log_file testlog
    spawn jdb
    expect \">\"
    send \"help\r\"
    expect \">\"
    send \"run Hello\r\"
    expect eof
"
    cat < testlog | grep -q "命令列表 \|command list" 
    CHECK_RESULT $? 0 0 "no find common list"
    cat < testlog | grep -q "VM 已启动:\|Started:"
    CHECK_RESULT $? 0 0 "no find VM Start"
    cat < testlog | grep -q  'Hello,world!'
    CHECK_RESULT $? 0 0 "no find Hello,world"

    jdeps -help | grep -i "用法:\|Usage:"
    CHECK_RESULT $? 0 0 "jdeps -help failed"
    jdeps -version | grep '[0-9]'
    CHECK_RESULT $? 0 0 "jdeps -version failed"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello.* testlog*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
