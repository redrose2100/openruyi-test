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
# @Author    :   xietian
# @Contact   :   xietian@uniontech.com
# @Date      :   2024.06.17
# @License   :   Mulan PSL v2
# @Desc      :   test utshell export
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    utshell -c "ulimit -H | grep unlimited"
    CHECK_RESULT $? 0 0 "ulimit -H fail"
    utshell -c "ulimit -m 2048 && ulimit -a | grep '2048'"
    CHECK_RESULT $? 0 0 "ulimit -m fail"
    utshell -c "ulimit -n 111 && ulimit -a | grep '111'"
    CHECK_RESULT $? 0 0 "ulimit -n fail"
    utshell -c "ulimit -p | grep 8"
    CHECK_RESULT $? 0 0 "ulimit -p fail"
    utshell -c "ulimit -s 9999 && ulimit -a | grep '9999'"
    CHECK_RESULT $? 0 0 "ulimit -s fail"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"