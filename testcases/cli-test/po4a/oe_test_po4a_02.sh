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
    
    DNF_INSTALL "po4a"
    mkdir tmp
    mkdir tmp/po
    echo "hello world" > tmp/master.txt
    echo "[po_directory] tmp/po/
[type: text] tmp/master.txt esp:tmp/po/translation.esp" > tmp/po4a.cfg
    echo "[po_directory] tmp/po/" > tmp/bug.cfg
    touch tmp/po/project.pot
    po4a-updatepo -f text -m tmp/master.txt -p tmp/po/esp.po
    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/po/esp.po
    sed -i 's/Language:/Language: esp/g' tmp/po/esp.po
    sed -i 's/charset=CHARSET/charset=UTF-8/g' tmp/po/esp.po

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    po4a tmp/po4a.cfg --keep-translations
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --keep-translations"
    rm -f tmp/po/translation.esp

    po4a tmp/po4a.cfg --rm-translations
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 1 0 "Failed to run command: po4a tmp/po4a.cfg --rm-translations"

    po4a tmp/po4a.cfg --translate-only tmp/po/translation.esp
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --translate-only tmp/po/translation.esp"
    rm -f tmp/po/translation.esp

    po4a tmp/po4a.cfg --variable lang=esp
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --variable lang=esp"
    rm -f tmp/po/translation.esp

    po4a tmp/po4a.cfg --srcdir . --destdir .
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --srcdir . --destdir ."
    rm -f tmp/po/translation.esp
    
    po4a tmp/po4a.cfg --porefs full
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --porefs full"
    rm -f tmp/po/translation.esp

    echo -n > tmp/po/project.pot
    po4a tmp/po4a.cfg --msgid-bugs-address "mybug@test" -f
    grep "mybug@test" tmp/po/project.pot
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --msgid-bugs-address mybug@test"

    echo -n > tmp/po/project.pot
    po4a tmp/po4a.cfg --copyright-holder "my copyright" -f
    grep "my copyright" tmp/po/project.pot
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --copyright-holder my copyright" 

    echo -n > tmp/po/project.pot
    po4a tmp/po4a.cfg --package-name "my package" -f 
    grep "my package" tmp/po/project.pot
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --package-name my package"

    echo -n > tmp/po/project.pot
    po4a tmp/po4a.cfg --package-version "2.0" -f 
    grep "PACKAGE 2.0" tmp/po/project.pot
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --package-version 2.0"

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
