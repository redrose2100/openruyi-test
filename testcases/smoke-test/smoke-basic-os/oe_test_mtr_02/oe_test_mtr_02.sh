#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.2.08
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-mtr
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "mtr"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    mtr -r -b dns.google | grep Snt
    CHECK_RESULT $? 0 0 "Display failure"
    out_c=$(mtr -r dns.google -c 15 | grep "_gateway" | awk '{print $4}')
    CHECK_RESULT $(out_c) 15 0 "-c Command execution failure"
    mtr -r -s 50 dns.google
    CHECK_RESULT $? 0 0 "-s Command execution failure"
    mtr --xml dns.google
    CHECK_RESULT $? 0 0 "-xml Command execution failure"
    out_csv=$(mtr --csv dns.google | grep "_gateway" | awk -F ',' '{print $6}')
    CHECK_RESULT $(out_csv) _gateway 0 "-csv Command execution failure"
    mtr -T -r dns.google
    CHECK_RESULT $? 0 0 "-T Command execution failure"
    mtr -u -r dns.google
    CHECK_RESULT $? 0 0 "-u Command execution failure"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
