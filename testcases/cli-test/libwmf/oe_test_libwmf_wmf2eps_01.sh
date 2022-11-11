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
# @Desc      :   Test "wmf2eps" command
# ##################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test(){
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL libwmf
    for i in {1..10}; do
        cp -f ./common/ant.wmf test"$i".wmf
    done
    LOG_INFO "End to prepare the test environment!"
}

function run_test(){
    LOG_INFO "Start to run test"
    wmf2eps --eps --auto test1.wmf
    test -e test1.eps
    CHECK_RESULT $? 0 0 "option --eps error"
    wmf2eps --ps --auto test2.wmf
    test -e test2.eps
    CHECK_RESULT $? 0 0 "option --ps error"
    wmf2eps --page=A4 --ps --auto test3.wmf
    cat test3.eps | grep Pages   
    CHECK_RESULT $? 0 0 "option --page error"
    wmf2eps --landscape --ps --auto test4.wmf
    cat test4.eps | grep Landscape
    CHECK_RESULT $? 0 0 "option --landscape error"
    wmf2eps --portrait --ps --auto test5.wmf
    cat test5.eps | grep Portrait
    CHECK_RESULT $? 0 0 "option --portrait error"
    wmf2eps --bbox=25x30+45+60 --ps --auto test6.wmf
    cat test6.eps | grep BoundingBox
    CHECK_RESULT $? 0 0 "option --bbox error"
    wmf2eps --centre --ps --auto test7.wmf
    cat test7.eps | grep scale
    CHECK_RESULT $? 0 0 "option --centre error"
    wmf2eps --maxpect --ps --auto test8.wmf
    cat test8.eps | grep scale
    CHECK_RESULT $? 0 0 "option --maxpect error"
    wmf2eps --title='test' --creator='author' --date='7月18日' --ps --auto test9.wmf
    cat test9.eps | grep author
    CHECK_RESULT $? 0 0 "option --title --creator --date error"
    wmf2eps --for='you' --ps --auto test10.wmf
    cat test10.eps | grep For
    CHECK_RESULT $? 0 0 "option --for error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test*
    LOG_INFO "Finish environment cleanup!"

}
main "$@"
