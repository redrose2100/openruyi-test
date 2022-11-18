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
    ckbcomp  -help 2>&1 | grep "Where legal args are:"
    ckbcomp  -? 2>&1 | grep "Where legal args are:"
    CHECK_RESULT $? 0 0 "Failed option: -?,-help"
    #指定字符映射表使用的编码
    ckbcomp  -charmap ARMSCII-8  ./common/symbolstest  2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -charmap"
    #在指定目录下搜索测试文件
    ckbcomp ./common/symbolstest -I /usr/  2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -I"
    #指定测试XKB键盘描述的键码名称
    ckbcomp -keycodes ./common/keycodestest us 2>&1 | grep "keymaps 0-127" 
    CHECK_RESULT $? 0 0 "Failed option: -keycodes"
    #指定测试XKB键盘描述的符号名称
    ckbcomp -symbols ./common/symbolstest  norman 2>&1 | grep "keymaps 0-127"
    CHECK_RESULT $? 0 0 "Failed option: -symbols"
    #指定测试XKB键盘描述文件使用的规则文件
    ckbcomp -rules ./base ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -rules"
    #指定测试XKB键盘描述文件使用的键盘型号
    ckbcomp -model pc105 ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -model"
    #指定测试XKB键盘描述文件使用的布局
    ckbcomp -layout us ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -layout"
    #指定布局变量
    ckbcomp -variant  $ ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -variant"
    #添加组件名选项
    ckbcomp -option terminate:ctrl_alt_bksp,lv3:ralt_switch,grp:alts_toggle ./common/symbolstest 2>&1 | grep "keycode"
    CHECK_RESULT $? 0 0 "Failed option: -option"
    #设置测试文件详细级别
    ckbcomp -v 1  ./common/symbolstest | grep "Down" 
    CHECK_RESULT $? 0 0 "Failed option: -v"
    
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"