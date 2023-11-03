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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.3.14
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-mandb
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "man-db"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    path=$(which mandb)
    CHECK_RESULT $path /usr/bin/mandb 0 "there is no executable program"
    mandb -V |grep mandb
    CHECK_RESULT $? 0 0 "version information is incorrect"
    mandb --help |grep -E "Usage|用法"
    CHECK_RESULT $? 0 0 "help information is incorrect"
    mandb -t vi
    CHECK_RESULT $? 0 0 "manual page display error"
    mandb -p | grep "/usr/share/man"
    CHECK_RESULT $? 0 0 "-p operation failure"
    mandb -d | grep "/usr/share/man"
    CHECK_RESULT $? 0 0 "-d Operation failure"
}

function post_test() {
    DNF_REMOVE
}

main $@

