#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xionglinhui
# @Contact   :   xionglinhui@uniontech.com
# @Date      :   2024-09-18
# @License   :   Mulan PSL v2
# @Desc      :   test luac
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    echo -n -e "print('Hello, world')" >script.lua
    echo "function add(a,b) return a+b end" > lib1.lua
    echo "function sub(a,b) return a-b end" > lib2.lua
    LOG_INFO "End of environment preparation."
}

function run_test() {
    LOG_INFO "Start testing..."
    luac -v |grep Lua
    CHECK_RESULT $? 0 0 "luac -v execute fail"
    luac -o script.luac script.lua
    CHECK_RESULT $? 0 0 "scipt.luac compile fail"
    luac -l script.lua
    CHECK_RESULT $? 0 0 "luac list fail"
    luac -p script.lua
    CHECK_RESULT $? 0 0 "luac parse only fail"
    luac -s -o script.luac script.lua
    CHECK_RESULT $? 0 0 "luac -s -o fail"
    luac -o stdin.luac - < script.lua
    CHECK_RESULT $? 0 0 "STDIN compilation failed"
    luac -l -l script.lua
    CHECK_RESULT $? 0 0 "Verbose listing failed"
    luac -o combined.luac lib1.lua lib2.lua
    luac -l combined.luac | grep -qE "add|sub"
    CHECK_RESULT $? 0 0 "Multi-file compilation failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf script* combined.luac  lib*.lua luac.out
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
