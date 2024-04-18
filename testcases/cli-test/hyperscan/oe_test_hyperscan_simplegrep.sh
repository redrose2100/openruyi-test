#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
#############################################
#@Author        :   sunqingwei
#@Contact       :   sunqingwei@uiontech.com
#@Date          :   20223/04/12
#@License       :   Mulan PSL v2
#@Desc          :   Test hyperscan simplegrep
##############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hyperscan hyperscan-devel libstdc++* gcc"
    cp -r /usr/include /usr/include_bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cp /usr/include/hs/* /usr/include
    cd /usr/share/doc/hyperscan/examples || return
    gcc -o simplegrep simplegrep.c -lhs -lstdc++ -lm
    test -e simplegrep
    CHECK_RESULT $? 0 0 "Compilation failure"
    ./simplegrep '[f|F]ile' pcapscan.cc | wc -l | grep 46
    CHECK_RESULT $? 0 0 "Query failure"
    grep -c -E '[fF]ile' pcapscan.cc | grep 33
    CHECK_RESULT $? 0 0 "Query failure2"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    mv -f /usr/include_bak /usr/include
    LOG_INFO "End to restore the test environment."
}

main "$@"