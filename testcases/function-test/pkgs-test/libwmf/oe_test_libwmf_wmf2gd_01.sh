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
# @Desc      :   Test "libwmf wmf2gd" command
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
    wmf2gd -t png --auto test1.wmf
    test -e test1.png
    CHECK_RESULT $? 0 0 "option -t error"
    wmf2gd --maxwidth=1200 --auto test2.wmf
    test -e test2.png
    CHECK_RESULT $? 0 0 "option --maxwidth error"
    wmf2gd --maxheight=1200 --auto test3.wmf
    test -e test3.png
    CHECK_RESULT $? 0 0 "option --maxheight error"
    wmf2gd --maxpect --auto test4.wmf
    test -e test4.png
    CHECK_RESULT $? 0 0 "option --maxpect error"
    wmf2gd --maxsize --auto test5.wmf
    test -e test5.png
    CHECK_RESULT $? 0 0 "option --maxsize error"
    wmf2gd --version | grep libwmf
    CHECK_RESULT $? 0 0 "option --version error"
    wmf2gd --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    wmf2gd --wmf-error=yes --auto test6.wmf
    test -e test6.png
    CHECK_RESULT $? 0 0 "option --wmf-error error"
    wmf2gd --wmf-debug=yes --auto test7.wmf
    test -e test7.png
    CHECK_RESULT $? 0 0 "option --wmf-debug error"
    wmf2gd --wmf-ignore-nonfatal=yes --auto test8.wmf
    test -e test8.png
    CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./test* 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
