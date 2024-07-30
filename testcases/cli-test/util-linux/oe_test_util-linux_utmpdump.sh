#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-07-15
# @License   :   Mulan PSL v2
# @Desc      :   Command test-utmpdump
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    utmpdump /var/run/utmp  > test1 2>&1
    CHECK_RESULT $? 0 0 "failed to view the utmp file"
    grep "Utmp dump of /var/run/utmp" test1
    CHECK_RESULT $? 0 0 "the expected result was not found"
    utmpdump /var/run/utmp -o tmp_output.txt 
    CHECK_RESULT $? 0 0 "an error occurred when the file generation command was executed"
    ls -l tmp_output.txt 
    CHECK_RESULT $? 0 0 "There is no tmp_output.txt file"
    utmpdump -r tmp_output.txt > /var/log/utmp
    CHECK_RESULT $? 0 0 "failed to write the dumped data back to the utmp file"
    utmpdump -h|grep Usage
    CHECK_RESULT $? 0 0 "failed to print help information. Procedure"
    utmpdump -V|grep "util-linux"
    CHECK_RESULT $? 0 0 "description failed to view the prlimit version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf  tmp_output.txt  test1
    LOG_INFO "End to clean the test environment."
}

main "$@"


