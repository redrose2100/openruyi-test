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
    qpdf --suppress-recovery --check ./common/infile.pdf
    CHECK_RESULT $? 0 0 "qpdf --suppress-recovery  running failed"
    qpdf --ignore-xref-streams --empty output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --ignore-xref-streams running failed"
    qpdf --stream-data=compress ./common/infile.pdf compress1.pdf && test -f compress1.pdf
    CHECK_RESULT $? 0 0 "qpdf --stream-data=compress running failed"
    qpdf --stream-data=preserve ./common/infile.pdf compress.pdf
    qpdf --stream-data=uncompress ./common/infile.pdf output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --stream-data=uncompress running failed"
    qpdf --compress-streams=y ./common/infile.pdf compress2.pdf && test -f compress2.pdf
    CHECK_RESULT $? 0 0 "qpdf --compress-streams running failed"
    qpdf --decode-level=none ./common/infile.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --decode-level=none running failed"
    qpdf --decode-level=generalized ./common/infile.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --decode-level=generalized running failed"
    qpdf --decode-level=specialized ./common/infile.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --decode-level=specialized running failed"
    qpdf --decode-level=all ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --decode-level=all running failed"
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
