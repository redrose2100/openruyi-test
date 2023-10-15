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
    qpdf --encrypt 123456 123456 40 --print=y --modify=y --extract=y --annotate=y -- ./common/infile.pdf output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=40 running failed"
    qpdf --encrypt 123456 123456 128 --accessibility=y --extract=y --assemble=y --annotate=y --form=y --modify-other=y --cleartext-metadata --use-aes=y --force-V4 -- ./common/infile.pdf output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 running failed"
    qpdf --encrypt 123456 123456 128 --print=full -- ./common/infile.pdf output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --print=full running failed"
    qpdf --encrypt 123456 123456 128 --print=low -- ./common/infile.pdf output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --print=low running failed"
    qpdf --encrypt 123456 123456 128 --print=none -- ./common/infile.pdf output5.pdf && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --print=none running failed"
    qpdf --encrypt 123456 123456 128 --modify=all -- ./common/infile.pdf output6.pdf && test -f output6.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --modify=all running failed"
    qpdf --encrypt 123456 123456 128 --modify=annotate -- ./common/infile.pdf output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --modify=annotate running failed"
    qpdf --encrypt 123456 123456 128 --modify=form -- ./common/infile.pdf output8.pdf && test -f output8.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --modify=form running failed"
    qpdf --encrypt 123456 123456 128 --modify=assembly -- ./common/infile.pdf output9.pdf && test -f output9.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --modify=assembly running failed"
    qpdf --encrypt 123456 123456 128 --modify=none -- ./common/infile.pdf output10.pdf && test -f output10.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 --modify=none running failed"
    qpdf --encrypt 123456 123456 256 --force-R5 -- ./common/infile.pdf output11.pdf && test -f output11.pdf
    CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 running failed"
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
