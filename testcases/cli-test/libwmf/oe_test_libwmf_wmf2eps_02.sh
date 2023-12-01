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
    for i in {1..8}; do
        cp -f ./common/ant.wmf test"$i".wmf
    done
    LOG_INFO "End to prepare the test environment!"
}

function run_test(){
    LOG_INFO "Start to run test"
    wmf2eps --version | grep libwmf
    CHECK_RESULT $? 0 0 "option --version error"
    wmf2eps --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    wmf2eps --wmf-error=yes --auto test1.wmf
    test -e test1.eps
    CHECK_RESULT $? 0 0 "option --wmf-error error"
    wmf2eps --wmf-debug=yes --auto test2.wmf
    test -e test2.eps
    CHECK_RESULT $? 0 0 "option --wmf-debug error"
    wmf2eps --wmf-ignore-nonfatal=yes --auto test3.wmf
    test -e test3.eps
    CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
    wmf2eps --wmf-diagnostics --auto test4.wmf
    test -e test4.eps 
    CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
    wmf2eps --wmf-fontdir=../common/libwmf --auto test5.wmf
    test -e test5.eps
    CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
    wmf2eps --wmf-sys-fontmap=../common/libwmf --wmf-sys-fonts --auto test6.wmf
    test -e test6.eps
    CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
    wmf2eps --wmf-xtra-fontmap=../common/libwmf --wmf-xtra-fonts --auto test7.wmf
    test -e test7.eps 
    CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
    wmf2eps --wmf-gs-fontmap=../common/libwmf --auto test8.wmf
    test -e test8.eps
    CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./result* ./test*
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
