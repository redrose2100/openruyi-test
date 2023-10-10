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

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    mkdir tmp
    echo "hello world" > tmp/master.txt
    echo "Hola, Mundo" > tmp/translation_esp.txt
    DNF_INSTALL "po4a"

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_02.po -M UTF-8 -L UTF-8
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_02.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_02.po -M UTF-8 -L UTF-8"
    
    po4a-gettextize --format text --master tmp/master.txt --localized tmp/translation_esp.txt --po tmp/translation_esp_022.po -M UTF-8 -L UTF-8
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_022.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_022.po -M UTF-8 -L UTF-8"

    po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_03.po -o tabs=split
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_03.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_03.po -o tabs=split"

    po4a-gettextize --format text --master tmp/master.txt --localized tmp/translation_esp.txt --po tmp/translation_esp_033.po --option tabs=split
    grep -Pz 'msgid "hello world"\nmsgstr "Hola, Mundo"' tmp/translation_esp_033.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_033.po --option tabs=split"

    po4a-gettextize -f text -m tmp/master.txt --msgid-bugs-address "test@test" | grep "Report-Msgid-Bugs-To: test@test"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --msgid-bugs-address test@test"

    po4a-gettextize -f text -m tmp/master.txt --copyright-holder "my copyright" | grep "Copyright (C) YEAR my copyright"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --copyright"

    po4a-gettextize -f text -m tmp/master.txt --package-name "a_new_package" | grep "a_new_package"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --package-name a_new_package"

    po4a-gettextize -f text -m tmp/master.txt --package-version "2.0" | grep "Project-Id-Version: PACKAGE 2.0"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --package-version 2.0"

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
