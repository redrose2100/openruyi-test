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
    echo "hello world" > tmp/master.txt

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po -o tabs=split
    grep "hello world" tmp/translation_03.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po -o tabs=split"
    
    po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_033.po --option tabs=split
    grep "hello world" tmp/translation_033.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_033.po --option tabs=split"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po -M UTF-8
    grep "charset=UTF-8" tmp/translation_04.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po -M UTF-8"
    
    po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_044.po --master-charset UTF-8
    grep "charset=UTF-8" tmp/translation_044.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_044.po --master-charset UTF-8"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_05.po --msgid-bugs-address "test@test"
    grep "Report-Msgid-Bugs-To: test@test" tmp/translation_05.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_05.po -o tabs=split -M UTF-8 -L UTF-8 --msgid-bugs-address test@test"

    po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_06.po --copyright-holder "my copyright"
    grep "my copyright" tmp/translation_06.po
    CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_06.po --copyrigh-holder"

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
