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

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    mkdir tmp
    echo "hello world" > tmp/master.txt
    DNF_INSTALL "po4a"

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --package-name "a_new_package" | grep "a_new_package"
    grep "a_new_package" tmp/translation_01.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --package-name a_new_package"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po --package-version "2.0"
    grep "Project-Id-Version: PACKAGE 2.0" tmp/translation_02.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po --package-version 2.0"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po --previous
    grep "hello world" tmp/translation_03.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po --previous"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po --no-previous
    grep "hello world" tmp/translation_04.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po --no-previous"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_05.po --msgmerge-opt="--no-wrap"
    grep "hello world" tmp/translation_05.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m master.en -p tmp/translation_05.po --msgmerge-opt=--no-wrap"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_06.po --porefs full
    grep "hello world" tmp/translation_06.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m master.en -p tmp/translation_06.po --porefs full"


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
