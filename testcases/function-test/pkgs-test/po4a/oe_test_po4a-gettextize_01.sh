#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.esp/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   brick-pid
#@Contact   	:   jianbo.lin@outlook.com
#@Date      	:   2023-09-13 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   test command po4a-gettextize
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "po4a"
    version=$(rpm -qa po4a | awk -F "-" '{print$2}')
    mkdir tmp
    echo "hello world" >tmp/master.txt
    echo "Hola, Mundo" >tmp/translation_esp.txt

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    po4a-gettextize --help | grep -Pz "Usage:\n.*po4a-gettextize"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --help"

    po4a-gettextize -h | grep -Pz "Usage:\n.*po4a-gettextize"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -h"

    po4a-gettextize --help-format 2>&1 | grep "List of valid formats"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --help-format"

    test "$(po4a-gettextize --version 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --version"

    test "$(po4a-gettextize -V 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -V"

    po4a-gettextize -f text -m --debug -l tmp/translation_esp.txt 2>&1 | grep "File --debug does not exist"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m --debug"

    po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_01.po --verbose
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_01.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_01.po"

    po4a-gettextize --format text --master tmp/master.txt --localized tmp/translation_esp.txt --po tmp/translation_esp_011.po --verbose
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_011.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_011.po"

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
