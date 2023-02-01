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
    qpdf --normalize-content=y ./common/infile.pdf output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --normalize-content running failed"
    qpdf --object-streams=preserve ./common/infile.pdf output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --object-streams=preserve running failed"
    qpdf --object-streams=disable ./common/infile.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --object-streams=disable running failed"
    qpdf --object-streams=generate ./common/infile.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --object-streams=generate running failed"
    qpdf --preserve-unreferenced ./common/infile.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --preserve-unreferenced running failed"
    qpdf --preserve-unreferenced-resources ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --preserve-unreferenced-resources running failed"
    qpdf --newline-before-endstream ./common/infile.pdf output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --newline-before-endstream running failed"
    qpdf --coalesce-contents ./common/infile.pdf output8.pdf && test -f output8.pdf
    CHECK_RESULT $? 0 0 "qpdf --coalesce-contents running failed"
    qpdf --flatten-annotations=print ./common/infile.pdf output9.pdf && test -f output9.pdf
    CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=print running failed"
    qpdf --flatten-annotations=screen ./common/infile.pdf output10.pdf && test -f output10.pdf
    CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=screen running failed"
    qpdf --flatten-annotations=all ./common/infile.pdf output11.pdf && test -f output11.pdf
    CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=all running failed"
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
