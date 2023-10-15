#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   lidikuan
# @Contact   :   1004224576@qq.com
# @Date      :   2022/7/18
# @Desc      :   Test "libwmf wmf2x" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test(){
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL libwmf
    for i in {1..8}; do
        cp -f ./common/ant.wmf test"$i".wmf
    done
    LOG_INFO "End to prepare the test environment!"
}

function run_test(){
    LOG_INFO "Start to run test"
    wmf2x display test1 test1.wmf 2> result1.txt &
    killall wmf2x
    cat result1.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "DISPLAY ERROR" 
    wmf2x --width=1200 test2.wmf 2> result2.txt &
    killall wmf2x
    cat result2.txt | grep "unable"
    CHECK_RESULT $? 1 0 "CHANGE WIDTH ERROR"
    wmf2x --height=1200 test3.wmf 2> result3.txt &
    killall wmf2x
    cat result3.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "CHANGE HEIGHT ERROR" 
    wmf2x --version | grep libwmf
    CHECK_RESULT $? 0 0 "option --version error"
    wmf2x --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    wmf2x --wmf-error=yes test4.wmf 2> result4.txt  &
    killall wmf2x
    cat result4.txt | grep "unable"
    CHECK_RESULT $? 1 0 "option --wmf-error error" 
    wmf2x --wmf-debug=yes test5.wmf 2> result5.txt  &
    killall wmf2x
    cat result5.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "option --wmf-debug error" 
    wmf2x --wmf-ignore-nonfatal=yes test6.wmf 2> result6.txt  &
    killall wmf2x
    cat result6.txt | grep "unable" 
    CHECK_RESULT $? 1 0 "option --wmf-ignore-nonfatal error" 
    wmf2x --wmf-diagnostics test7.wmf 2> result7.txt  &
    killall wmf2x
    cat result7.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "opition --wmf-diagnostics error"
    wmf2x --wmf-fontdir= ../common test8.wmf 2> result8.txt &
    killall wmf2x
    cat result8.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "opition --wmf-fontdir error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./result* && rm -rf ./test*
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
