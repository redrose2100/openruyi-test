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
#@Desc      	:   test command po4a-normalize
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "po4a"
    mkdir tmp
    echo "hello world" > tmp/master.txt

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    po4a-normalize -f text tmp/master.txt --blank
    grep 'hello world' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --blank"
    grep -Pz 'msgstr "[^ "]{1}"' po4a-normalize.po
    CHECK_RESULT $? 1 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --blank"
    rm -rf po4a-normalize.output  po4a-normalize.po

    po4a-normalize -f text tmp/master.txt -b
    grep 'hello world' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -b"
    grep -Pz 'msgstr "[^ "]{1}"' po4a-normalize.po
    CHECK_RESULT $? 1 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -b"
    rm -rf po4a-normalize.output  po4a-normalize.po

    po4a-normalize -f text tmp/master.txt -o tabs=split
    test -f po4a-normalize.output && test -f po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -o tabs=split"
    rm -rf po4a-normalize.output  po4a-normalize.po
    
    po4a-normalize -f text tmp/master.txt --option tabs=split
    grep 'hello world' po4a-normalize.output && grep 'msgid "hello world"' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --option tabs=split"
    rm -rf po4a-normalize.output  po4a-normalize.po

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
