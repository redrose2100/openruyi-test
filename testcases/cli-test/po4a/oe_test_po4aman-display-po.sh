#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   brick-pid
#@Contact   	:   jianbo.lin@outlook.com
#@Date      	:   2023-09-13 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   test command po4aman-display-po
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "po4a"
    mkdir tmp
    echo "hello world" > tmp/master.txt
    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_Esp.po
    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/translation_Esp.po

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    if [[ "$(which po4a-display-man 2>/dev/null)" != "" ]];then
        po4a-display-man -h | grep -i "Usage: "
        CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -h"

        po4a-display-man -p tmp/translation_Esp.po -m tmp/master.txt | grep "Hola, Mundo"
        CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -p tmp/translation_Esp.po"

        po4a-display-man -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split | grep "Hola, Mundo"
        CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split"
    else
        po4aman-display-po -h | grep -i "Usage: "
        CHECK_RESULT $? 0 0 "Failed to run command: po4aman-display-po -h"

        po4aman-display-po -p tmp/translation_Esp.po -m tmp/master.txt | grep "Hola, Mundo"
        CHECK_RESULT $? 0 0 "Failed to run command: po4aman-display-po -p tmp/translation_Esp.po"

        po4aman-display-po -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split | grep "Hola, Mundo"
        CHECK_RESULT $? 0 0 "Failed to run command: po4aman-display-po -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split"
    fi
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf tmp
    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"
