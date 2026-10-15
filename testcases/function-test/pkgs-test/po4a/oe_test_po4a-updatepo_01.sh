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
#@Desc      	:   test command po4a
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

    po4a-updatepo --help | grep -Pz "Usage:\n.*po4a-updatepo"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --help"

    po4a-updatepo -h | grep -Pz "Usage:\n.*po4a-updatepo"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -h"

    po4a-updatepo --help-format 2>&1 | grep "List of valid formats"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --help-format"

    test "$(po4a-updatepo --version 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --version"

    test "$(po4a-updatepo -V 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -V"

    po4a-updatepo -f text -m tmp/master.txt -p out.po -M --debug 2>&1 | grep "debug"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p out.po -M --debug"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --verbose
    grep "hello world" tmp/translation_01.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --verbose"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po -M UTF-8
    grep "hello world" tmp/translation_02.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po -M UTF-8"

    po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_022.po --master-charset UTF-8
    grep "hello world" tmp/translation_022.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_022.po -M UTF-8"

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
