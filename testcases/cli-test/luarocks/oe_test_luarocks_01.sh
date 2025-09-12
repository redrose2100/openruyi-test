#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2025/09/12
# @License   :   Mulan PSL v2
# @Desc      :   test  luarocks
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "luarocks gcc lua-devel luajit-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    luarocks --version
    CHECK_RESULT $? 0 0 "Failed to verify luarocks installation"
    luarocks install luasocket
    CHECK_RESULT $? 0 0 "luasocket installation failed"
    luarocks list | grep -q "luasocket"
    CHECK_RESULT $? 0 0 "luasocket not found in installed packages list"
    eval "$(luarocks path --bin)"
    CHECK_RESULT $? 0 0 "Failed to set Lua path environment variables"
    luarocks search luasocket | grep -q "luasocket"
    CHECK_RESULT $? 0 0 "Failed to search for luasocket package"
    luarocks help
    CHECK_RESULT $? 0 0 "Failed to display luarocks help"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    luarocks remove luasocket
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

