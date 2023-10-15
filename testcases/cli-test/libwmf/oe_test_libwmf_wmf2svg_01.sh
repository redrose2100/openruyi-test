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
# @Desc      :   Test "libwmf wmf2svg" command
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
    wmf2svg -z --auto test1.wmf
    test -e test1.svgz
    CHECK_RESULT $? 0 0 "option -z error"
    wmf2svg --inline --auto test2.wmf
    cat test2.svg | grep xml
    CHECK_RESULT $? 0 0 "option --inline error"
    wmf2svg --desc=description --auto test3.wmf
    cat test3.svg | grep description
    CHECK_RESULT $? 0 0 "option --desc error"
    wmf2svg --maxwidth=1200 --auto test4.wmf
    cat test4.svg | grep polygon
    CHECK_RESULT $? 0 0 "option --maxwidth error"
    wmf2svg --maxheight=1200 --auto test5.wmf
    cat test5.svg | grep polygon
    CHECK_RESULT $? 0 0 "option --maxheight error"
    wmf2svg --maxpect --auto test6.wmf
    test -e test6.svg
    CHECK_RESULT $? 0 0 "option --maxpect error"
    wmf2svg --maxsize --auto test7.wmf
    test -e test7.svg
    CHECK_RESULT $? 0 0 "option --maxsize error"
    wmf2svg --version | grep libwmf
    CHECK_RESULT $? 0 0 "option --version error"
    wmf2svg --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    wmf2svg --wmf-error=yes --auto test8.wmf
    test -e test8.svg
    CHECK_RESULT $? 0 0 "option --wmf-error error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./test* 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
