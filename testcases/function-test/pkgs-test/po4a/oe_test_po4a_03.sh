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

    rm -f tmp/po/translation.esp
    po4a tmp/po4a.cfg --msgmerge-opt "--no-wrap"
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --msgmerge-opt --no-wrap"

    rm -f tmp/po/translation.esp
    po4a tmp/po4a.cfg --no-previous 
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --no-previous"

    rm -f tmp/po/translation.esp
    po4a tmp/po4a.cfg --previous
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --previous"

    po4a tmp/po4a.cfg --force
    test -f tmp/po/project.pot && test -f tmp/po/esp.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --force"

    po4a tmp/bug.cfg --debug 2>&1 | grep "cmd=\[po_directory\]"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/bug.cfg --debug"

    rm -rf tmp/po/translation.esp
    sed -i 's/msgstr "Hola, Mundo"/msgstr ""/g' tmp/po/esp.po
    po4a tmp/po4a.cfg --stamp
    test -f tmp/po/translation.esp.po4a-stamp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --stamp"
    rm -rf tmp/po/translation.esp.po4a-stamp

    po4a tmp/po4a.cfg --no-translations
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 1 0 "Failed to run command: po4a tmp/po4a.cfg --no-translations"

    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/po/esp.po
    po4a tmp/po4a.cfg --no-update
    test -f tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --no-update"


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
