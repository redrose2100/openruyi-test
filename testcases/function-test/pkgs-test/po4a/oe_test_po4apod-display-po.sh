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
#@Desc      	:   test command po4a-display-pod and msguntypot
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
    echo "hello world old" > tmp/old.txt
    po4a-updatepo -f text -m tmp/old.txt -p tmp/old.pot
    echo "hello world new" > tmp/new.txt
    po4a-updatepo -f text -m tmp/new.txt -p tmp/new.pot

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # test po4a-display-pod
    po4a-display-pod -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -h"

    po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt | grep -i "translated"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt"

    po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split | grep -i "translated"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split"

    # test msguntypot
    msguntypot -h | grep -Pz "Usage:\n.*msguntypot"
    CHECK_RESULT $? 0 0 "Failed to run command: msguntypotd -h"
    
    msguntypot -o tmp/old.pot -n tmp/new.pot tmp/old.pot
    grep "hello world new" tmp/old.pot
    CHECK_RESULT $? 0 0 "Failed to run command: msguntypot -o tmp/old.pot -n tmp/new.pot tmp/old.pot"

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
