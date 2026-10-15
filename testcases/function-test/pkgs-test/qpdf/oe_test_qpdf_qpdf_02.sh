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
    qpdf --copy-encryption=./common/encrypt.pdf --encryption-file-password=123456 --empty output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --copy-encryption --encryption-file-password running failed"
    qpdf --copy-encryption=./common/encrypt.pdf --encryption-file-password=123456 --empty output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --encryption-file-password=password running failed"
    qpdf --password=123456 --decrypt ./common/encrypt.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --decrypt running failed"
    qpdf --password-is-hex-key ./common/encrypt.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --password-is-hex-key running failed"
    qpdf --decrypt --password=123456 --suppress-password-recovery ./common/encrypt.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --suppress-password-recovery running failed"
    qpdf --password-mode=bytes --encrypt 123456 123456 256 -- ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --password-mode=bytes running failed"
    qpdf --password-mode=hex-bytes --encrypt user-password owner-password 256 -- ./common/infile.pdf output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --password-mode=hex-bytes running failed"
    qpdf --password-mode=unicode --encrypt user-password owner-password 256 -- ./common/infile.pdf output8.pdf && test -f output8.pdf
    CHECK_RESULT $? 0 0 "qpdf --password-mode=unicode running failed"
    qpdf --password-mode=auto --encrypt user-password owner-password 256 -- ./common/infile.pdf output9.pdf && test -f output9.pdf
    CHECK_RESULT $? 0 0 "qpdf --password-mode=auto running failed"
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
