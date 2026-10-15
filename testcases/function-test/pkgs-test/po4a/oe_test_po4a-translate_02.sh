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

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "po4a"
    mkdir tmp
    echo "hello world" > tmp/master.txt
    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_Esp.po
    sed -i 's/msgstr ""/msgstr "Hola, Mundo"/g' tmp/translation_Esp.po

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_5.txt -k 85 -w 85
    grep "Hola, Mundo" tmp/result_5.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_5.txt -k 85 -w 85"
    
    po4a-translate --format text --master tmp/master.txt --po tmp/translation_Esp.po --localized tmp/result_6.txt --keep 85 --width 85
    grep "Hola, Mundo" tmp/result_6.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_6.txt -k 85 -w 85"

    po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_7.txt -M UTF-8 -L UTF-8
    grep "Hola, Mundo" tmp/result_7.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_7.txt -M UTF-8 -L UTF-8"
    
    po4a-translate --format text --master tmp/master.txt --po tmp/translation_Esp.po --localized tmp/result_8.txt --master-charset UTF-8 --localized-charset UTF-8
    grep "Hola, Mundo" tmp/result_8.txt
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_8.txt -M UTF-8 -L UTF-8"

    echo "PO4A-HEADER: position=Hola, Mundo; mode=after; endboundary=</section>
    additional text" > tmp/addendum
    po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -a tmp/addendum -A UTF-8 | grep "additional text"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p tmp/translation_Esp.po -a addendum -A UTF-8" 
    
    po4a-translate --format text --master tmp/master.txt --po tmp/translation_Esp.po --addendum tmp/addendum --addendum-charset UTF-8 | grep "additional text"
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p tmp/translation_Esp.po -a addendum -A UTF-8"

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
