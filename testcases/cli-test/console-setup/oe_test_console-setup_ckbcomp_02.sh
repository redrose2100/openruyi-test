# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   chen zhenghao
# @Contact   	:   zhenghao@isrc.iscas.ac.cn
# @Date      	:   2022-11-7
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of byacc package
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL byacc
    test -d tmp || mkdir tmp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {

    LOG_INFO "Start testing..."

    #生成XKB紧凑键图
    ckbcomp -compact ./common/symbolstest 2>&1 | grep "keycode 101"
    CHECK_RESULT $? 0 0 "Failed option: -compact"
    #生成FreeBSD键图
    ckbcomp -freebsd ./common/symbolstest | grep "#"
    CHECK_RESULT $? 0 0 "Failed option: -freebsd"
    #为测试文件指定控制码，bs指定符合vt100的行为
    ckbcomp -backspace bs ./common/symbolstest 2>&1 | grep "Next Scroll_Forward"
    CHECK_RESULT $? 0 0 "Failed option: -backspace"
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"