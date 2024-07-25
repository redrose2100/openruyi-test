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
#@Desc      	:   test command po4a-translate
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "po4a"
    mkdir tmp
    echo "hello world" >tmp/master.txt
    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_Esp.po
    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/translation_Esp.po
    version=$(rpm -qa po4a | awk -F "-" '{print$2}')

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    po4a-translate -h | grep -Pz "Usage:\n.*po4a-translate"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translated -h"

    po4a-translate --help | grep -Pz "Usage:\n.*po4a-translate"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --help"

    po4a-translate --help-format 2>&1 | grep "List of valid formats"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --help-format"

    test "$(po4a-translate --version 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --version"

    test "$(po4a-translate -V 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -V"

    po4a-translate -f text -m tmp/master.txt -p --debug 2>&1 | grep "debug"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p --debug"

    po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_1.txt --verbose
    grep "Hola, Mundo" tmp/result_1.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_1.txt --verbose"

    po4a-translate --format text --master tmp/master.txt --po tmp/translation_Esp.po --localized tmp/result_2.txt --verbose
    grep "Hola, Mundo" tmp/result_2.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_2.txt --verbose"

    po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_3.txt -o tabs=split
    grep "Hola, Mundo" tmp/result_3.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_3.txt -o tabs=split"

    po4a-translate --format text --master tmp/master.txt --po tmp/translation_Esp.po --localized tmp/result_4.txt --option tabs=split
    grep "Hola, Mundo" tmp/result_4.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_4.txt -o tabs=split"

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
