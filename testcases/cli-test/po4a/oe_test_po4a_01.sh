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
    mkdir tmp/po
    echo "hello world" >tmp/master.txt
    echo "[po_directory] tmp/po/
[type: text] tmp/master.txt esp:tmp/po/translation.esp" >tmp/po4a.cfg
    touch tmp/po/project.pot
    po4a-updatepo -f text -m tmp/master.txt -p tmp/po/esp.po
    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/po/esp.po
    sed -i 's/Language:/Language: esp/g' tmp/po/esp.po
    sed -i 's/charset=CHARSET/charset=UTF-8/g' tmp/po/esp.po
    version=$(rpm -qa po4a | awk -F "-" '{print$2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    po4a -h | grep -Pz "Usage:\n.*po4a"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a -h"

    po4a --help | grep -Pz "Usage:\n.*po4a"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a --help"

    test "$(po4a --version 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a --version"

    test "$(po4a -V 2>&1 | awk 'NR==1{print $3}' | awk '{sub(/\.$/, ""); print $1}')" == "$version"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a -V"

    po4a --verbose tmp/po4a.cfg -M UTF-8 -L UTF-8
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to get content of tmp/po/translation.esp"
    rm -rf tmp/po/translation.esp

    po4a --verbose tmp/po4a.cfg --master-charset UTF-8 --localized-charset UTF-8
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to get content of tmp/po/translation.esp"
    rm -rf tmp/po/translation.esp

    po4a tmp/po4a.cfg -k 85
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
    rm -rf tmp/po/translation.esp

    po4a tmp/po4a.cfg --keep 85
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
    rm -rf tmp/po/translation.esp

    po4a tmp/po4a.cfg -o tabs=split -q
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
    rm -rf tmp/po/translation.esp

    po4a tmp/po4a.cfg --option tabs=split --quiet
    grep "Hola, Mundo" tmp/po/translation.esp
    CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE "$@"
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
