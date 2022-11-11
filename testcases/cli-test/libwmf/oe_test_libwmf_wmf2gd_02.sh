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
    for i in {1..6}; do
        cp ./common/ant.wmf test"$i".wmf
    done
    LOG_INFO "End to prepare the test environment!"
}

function run_test(){
    LOG_INFO "Start to run test"  
    wmf2gd --wmf-diagnostics --auto test1.wmf
    test -e test1.png 
    CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
    wmf2gd --wmf-fontdir= ../common/libwmf --auto test2.wmf
    test -e test2.png
    CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
    wmf2gd --wmf-sys-fontmap=../common/libwmf --wmf-sys-fonts --auto test3.wmf
    test -e test3.png 
    CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
    wmf2gd --wmf-xtra-fontmap=../common/libwmf --wmf-xtra-fonts --auto test4.wmf
    test -e test4.png 
    CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
    wmf2gd --wmf-gs-fontmap=../common/libwmf --auto test5.wmf
    test -e test5.png
    CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
    wmf2gd --wmf-write=metafile.xml test6.wmf
    cat metafile.xml | grep "xml version"
    CHECK_RESULT $? 0 0 "option --wmf-write error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf result* test* metafile.xml 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
