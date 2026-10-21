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
# @Desc      :   Test "wmf2fig" command
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
    wmf2fig --figunit=1300 --auto test1.wmf
    cat test1.fig | grep FIG
    CHECK_RESULT $? 0 0 "option --figunit error"
    wmf2fig --page=A3 --auto test2.wmf
    cat test2.fig | grep A3
    CHECK_RESULT $? 0 0 "option --page error"
    wmf2fig --landscape --auto test3.wmf
    cat test3.fig | grep Landscape
    CHECK_RESULT $? 0 0 "option --landscape error"
    wmf2fig --portrait --auto test4.wmf
    cat test4.fig | grep Portrait
    CHECK_RESULT $? 0 0 "option --portrait error" 
    wmf2fig --maxpect --auto test5.wmf
    cat test5.fig | grep draw_polygon
    CHECK_RESULT $? 0 0 "option --maxpect error"
    wmf2fig --no-margins --auto test6.wmf
    cat test6.fig | grep polygon
    CHECK_RESULT $? 0 0 "option --no-margins error"
    wmf2fig --flat --auto test7.wmf
    cat test7.fig | grep polygon
    CHECK_RESULT $? 0 0 "option --flat error"
    wmf2fig --image=eps --auto test8.wmf
    test -e test8.fig 
    CHECK_RESULT $? 0 0 "option --image error"
    wmf2fig --title='test' --creator='author' --date='7月18日' --auto test9.wmf
    cat test9.fig | grep test 
    CHECK_RESULT $? 0 0 "option --title --creator --date error"
    wmf2fig --for='you' --auto test10.wmf
    cat test10.fig | grep For  
    CHECK_RESULT $? 0 0 "option --for error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./test* 
    LOG_INFO "Finish environment cleanup!"
}
main "$@" 
