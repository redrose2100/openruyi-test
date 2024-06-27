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
# @Date      :   2024.05.11
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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su - test -c 'echo {a..z} | tr " " "\n" >test.log'
    test -f /home/test/test.log
    CHECK_RESULT $? 0 0 "File generation failed"
    su - test -c "readarray -O 7 myarr <test.log && echo \${#myarr[@]}" |grep 26
    CHECK_RESULT $? 0 0 "Incorrect array reading"
    su - test -c "readarray -s 10 myarr <test.log && echo \${myarr[@]}" | grep '^k.*z$'
    CHECK_RESULT $? 0 0 "Failed to display the last 16 letters"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"