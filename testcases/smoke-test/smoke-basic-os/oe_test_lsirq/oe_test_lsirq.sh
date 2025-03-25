#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-04-01
# @License   :   Mulan PSL v2
# @Desc      :   test lsirq
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux"
    ver=$(rpm -qi util-linux | grep -oP 'Version\s+:\s+\K[\d.]+')
    echo "util-linux:$ver"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    lsirq
    CHECK_RESULT $? 0 0 "lsirq execute fail"
    lsirq --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "lsirq --help execute fail"
    lsirq --version | grep -i lsirq
    CHECK_RESULT $? 0 0 "lsirq --version execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
