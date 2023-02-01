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

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "qpdf"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    qpdf --generate-appearances ./common/infile.pdf output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --generate-appearances running failed"
    qpdf --optimize-images ./common/infile.pdf output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --optimize-images running failed"
    qpdf --oi-min-width=128 ./common/infile.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --oi-min-width running failed"
    qpdf --oi-min-height=128 ./common/infile.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --oi-min-height running failed"
    qpdf -oi-min-area=16384 ./common/infile.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --oi-min-height running failed"
    qpdf --externalize-inline-images ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --externalize-inline-images running failed"
    qpdf --ii-min-bytes=1024 ./common/infile.pdf output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --ii-min-bytes running failed"
    qpdf --keep-inline-images ./common/infile.pdf output8.pdf && test -f output8.pdf
    CHECK_RESULT $? 0 0 "qpdf --keep-inline-images running failed"
    qpdf --remove-page-labels ./common/infile.pdf output9.pdf && test -f output9.pdf
    CHECK_RESULT $? 0 0 "qpdf --remove-page-labels running failed"
    qpdf --qdf ./common/infile.pdf output10.pdf && test -f output10.pdf
    CHECK_RESULT $? 0 0 "qpdf --qdf running failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE 
    rm -rf *.pdf
    LOG_INFO "End to restore the test environment."
}

main "$@"
