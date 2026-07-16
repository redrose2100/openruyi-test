#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-14
# @License   :   Mulan PSL v2
# @Desc      :   runc basic commands test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    if yum list 2>/dev/null | grep -q "docker-runc"; then
        DNF_INSTALL "docker-runc"
    else
        DNF_INSTALL "runc"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # --version 显示版本信息
    runc --version | grep -q "runc version"
    CHECK_RESULT $? 0 0 "runc --version failed"
    
    # -v 显示版本信息
    runc -v | grep -q "runc version"
    CHECK_RESULT $? 0 0 "runc -v failed"
    
    # --help 显示帮助信息
    runc --help | grep -q "Open Container Initiative runtime"
    CHECK_RESULT $? 0 0 "runc --help failed"
    
    # -h 显示帮助信息
    runc -h | grep -q "Open Container Initiative runtime"
    CHECK_RESULT $? 0 0 "runc -h failed"
    
    # features 显示支持的特性
    runc features | grep -q "ociVersionMin"
    CHECK_RESULT $? 0 0 "runc features failed"
    
    # checkpoint 命令帮助
    runc checkpoint --help
    CHECK_RESULT $? 0 0 "runc checkpoint --help failed"
    
    # create 命令帮助
    runc create --help
    CHECK_RESULT $? 0 0 "runc create --help failed"
    
    # delete 命令帮助
    runc delete --help
    CHECK_RESULT $? 0 0 "runc delete --help failed"
    
    # events 命令帮助
    runc events --help
    CHECK_RESULT $? 0 0 "runc events --help failed"
    
    # exec 命令帮助
    runc exec --help
    CHECK_RESULT $? 0 0 "runc exec --help failed"
    
    # kill 命令帮助
    runc kill --help
    CHECK_RESULT $? 0 0 "runc kill --help failed"
    
    # list 命令帮助
    runc list --help
    CHECK_RESULT $? 0 0 "runc list --help failed"
    
    # pause 命令帮助
    runc pause --help
    CHECK_RESULT $? 0 0 "runc pause --help failed"
    
    # ps 命令帮助
    runc ps --help
    CHECK_RESULT $? 0 0 "runc ps --help failed"
    
    # restore 命令帮助
    runc restore --help
    CHECK_RESULT $? 0 0 "runc restore --help failed"
    
    # resume 命令帮助
    runc resume --help
    CHECK_RESULT $? 0 0 "runc resume --help failed"
    
    # run 命令帮助
    runc run --help
    CHECK_RESULT $? 0 0 "runc run --help failed"
    
    # spec 命令帮助
    runc spec --help
    CHECK_RESULT $? 0 0 "runc spec --help failed"
    
    # start 命令帮助
    runc start --help
    CHECK_RESULT $? 0 0 "runc start --help failed"
    
    # state 命令帮助
    runc state --help
    CHECK_RESULT $? 0 0 "runc state --help failed"
    
    # update 命令帮助
    runc update --help
    CHECK_RESULT $? 0 0 "runc update --help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    LOG_INFO "Finish environment cleanup!"
}

main "$@"