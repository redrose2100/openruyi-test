#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024.05.21
# @License   :   Mulan PSL v2
# @Desc      :   readarray using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    useradd -m -s /bin/utshell test
    su - test -c "echo \$0" |grep -i utshell
    CHECK_RESULT $? 0 0 "Not using the utshell environment"
    cp ./common/testread.sh /home/test
    script_file="/home/test/testread.sh"
    chmod 755 "$script_file"
    chown test:test "$script_file"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su - test -c "echo 'test' >alpha.log"
    su - test -c "readarray < alpha.log -d '\\t' target_array"
    CHECK_RESULT $? 0 0 "Execution failed"
    su - test -c "bash ${script_file} |grep -i test"
    CHECK_RESULT $? 0 0 "Execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    rm -rf "$script_file"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
