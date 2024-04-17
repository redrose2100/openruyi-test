#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   linwang
#@Contact   	:   linwang@techfantasy.com.cn
#@Date      	:   2022-07
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test qpdf
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "qpdf"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    qpdf --linearize --static-id --linearize-pass1=temp.pdf ./common/infile.pdf output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --linearize running failed"
    qpdf --min-version=1.6 ./common/infile.pdf output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --min-version running failed"
    qpdf --force-version=1.4 ./common/infile.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --force-version running failed"
    qpdf --deterministic-id ./common/infile.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --deterministic-id running failed"
    qpdf --static-id ./common/infile.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --static-id running failed"
    qpdf --static-aes-iv --static-id --encrypt test123 test123 256 -- ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --static-aes-iv running failed"
    qpdf --qdf --no-original-object-ids ./common/infile.pdf output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --no-original-object-ids running failed"
    qpdf --show-encryption --password=123456 ./common/encrypt.pdf | grep "modify"
    CHECK_RESULT $? 0 0 "qpdf --show-encryption running failed"
    qpdf --show-encryption-key --check ./common/encrypt.pdf --password=123456 | grep "Version"
    CHECK_RESULT $? 0 0 "qpdf --show-encryption-key running failed"
    qpdf --linearize ./common/infile.pdf linear.pdf
    qpdf --check-linearization linear.pdf | grep "pdf"
    CHECK_RESULT $? 0 0 "qpdf --check-linearization running failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@" 
    rm -rf '*.pdf'
    LOG_INFO "End to restore the test environment."
}

main "$@"
