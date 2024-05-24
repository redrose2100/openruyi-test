#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-05-24
# @License   :   Mulan PSL v2
# @Desc      :   Command test-colrm
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    echo -e "123456789" | colrm 3 6 |grep 12789
    CHECK_RESULT $? 0 0 "failed to delete columns 3 through 6"
    echo "hello word" > a.txt
    CHECK_RESULT $? 0 0 "file creation failure"
    colrm 4 6 < a.txt |grep helword
    CHECK_RESULT $? 0 0 "failed to delete columns 3 through 6 from the file"
    colrm -h|grep help
    CHECK_RESULT $? 0 0 "description failed to view the dc help information"
    colrm -V|grep colrm
    CHECK_RESULT $? 0 0 "description failed to view the dc version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf a.txt
    LOG_INFO "End to clean the test environment."
}

main "$@"


