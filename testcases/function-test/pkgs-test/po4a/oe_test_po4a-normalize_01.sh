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

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "po4a"
    mkdir tmp
    echo "hello world" >tmp/master.txt
    version=$(rpm -qa po4a | awk -F "-" '{print$2}')

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    po4a-normalize -h | grep -Pz "Usage:\n.*po4a-normalize"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalized -h"

    po4a-normalize --help | grep -Pz "Usage:\n.*po4a-normalize"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --help"

    po4a-normalize --help-format 2>&1 | grep "List of valid formats"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --help-format"

    test "$(po4a-normalize --version 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --version"

    test "$(po4a-normalize -V 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -V"

    po4a-normalize --format text tmp/master.txt
    grep 'hello world' po4a-normalize.output && grep 'msgid "hello world"' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --format text tmp/master.txt"
    rm -rf po4a-normalize.output po4a-normalize.po

    po4a-normalize -f text tmp/master.txt -M UTF-8
    grep 'hello world' po4a-normalize.output && grep 'msgid "hello world"' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt"
    rm -rf po4a-normalize.output po4a-normalize.po

    po4a-normalize -f text tmp/master.txt --master-charset UTF-8
    grep 'hello world' po4a-normalize.output && grep 'msgid "hello world"' po4a-normalize.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt"
    rm -rf po4a-normalize.output po4a-normalize.po

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf tmp
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}

    LOG_INFO "End to restore the test environment."
}

main "$@"
