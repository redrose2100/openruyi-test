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
    for i in {1..4}; do
        cp ./common/ant.wmf test"$i".wmf
    done
    LOG_INFO "End to prepare the test environment!"
}

function run_test(){
    LOG_INFO "Start to run test"
    wmf2x --wmf-sys-fontmap=../common/libwmf --wmf-sys-fonts test1.wmf 2> result1.txt  &
    killall wmf2x
    cat result1.txt | grep "ERROR" 
    CHECK_RESULT $? 1 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
    wmf2x --wmf-xtra-fontmap=../common --wmf-xtra-fonts test2.wmf 2> result2.txt  &
    killall wmf2x
    cat result2.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error" 
    wmf2x --wmf-gs-fontmap=../common/libwmf test3.wmf 2> result3.txt &
    killall wmf2x
    cat result3.txt | grep "ERROR"
    CHECK_RESULT $? 1 0 "option --wmf-gs-fontmap error" 
    wmf2x --wmf-write=metafile.xml test4.wmf & 
    cat metafile.xml | grep "selectobject"
    killall wmf2x
    CHECK_RESULT $? 0 0 "option --wmf-write error"
    LOG_INFO "End of test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    rm -rf result* test* metafile.xml
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
