#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

####################################
#@Author    	:   dongQ
#@Contact   	:   dongqi1@kylinos.cn
#@Date      	:   2024-05-09
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test zsh
#####################################


source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL zsh
    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    zsh -c 'echo "Hello, Zsh!"'
    CHECK_RESULT $? 0 0 "zsh test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Nothing to do."
}

main "$@"

