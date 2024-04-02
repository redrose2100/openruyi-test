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
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-04-20
# @License   :   Mulan PSL v2
# @Desc      :   压缩对比工具-xzcmp
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    cd /home || exit
    echo "sdfasd1223123" > 1.txt
    xz 1.txt
    echo "223424435rrte" > 2.txt
    xz 2.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd /home || exit
    xzcmp 1.txt.xz 2.txt.xz|grep "differ"
    CHECK_RESULT $? 0 0 "bzcmp function error" 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /home/1.txt.xz
    rm -rf /home/2.txt.xz
    export LANG=$Default_LANG
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
