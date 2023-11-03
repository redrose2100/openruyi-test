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
    qpdf --empty --pages ./common/infile.pdf 1-3 -- output1.pdf && test -f output1.pdf
    CHECK_RESULT $? 0 0 "qpdf --pages  running failed"
    qpdf --empty --keep-files-open=y --pages ./common/infile.pdf 1-3 -- output2.pdf && test -f output2.pdf
    CHECK_RESULT $? 0 0 "qpdf --keep-files-open  running failed"
    qpdf --empty --keep-files-open-threshold=50 --pages ./common/infile.pdf 1-3 -- output3.pdf && test -f output3.pdf
    CHECK_RESULT $? 0 0 "qpdf --keep-files-open-threshold  running failed"
    qpdf --collate --empty --pages ./common/infile.pdf 1-3 ./common/1.pdf 4-6 -- output4.pdf && test -f output4.pdf
    CHECK_RESULT $? 0 0 "qpdf --collate  running failed"
    qpdf ./common/infile.pdf output5.pdf --rotate=+90:1-2 --rotate=180:3-4 && test -f output5.pdf
    CHECK_RESULT $? 0 0 "qpdf --rotate  running failed"
    qpdf --split-pages=2 ./common/infile.pdf output6.pdf && test -f output6-1-2.pdf
    CHECK_RESULT $? 0 0 "qpdf --split-pages  running failed"
    qpdf ./common/infile.pdf --overlay ./common/stamp.pdf -- output7.pdf && test -f output7.pdf
    CHECK_RESULT $? 0 0 "qpdf --overlay  running failed"
    qpdf ./common/infile.pdf --overlay ./common/stamp.pdf --to=1-3 --from=1 --repeat=1 -- output8.pdf && test -f output8.pdf
    CHECK_RESULT $? 0 0 "qpdf --overlay option  running failed"
    qpdf ./common/infile.pdf --underlay ./common/stamp.pdf -- output9.pdf && test -f output9.pdf
    CHECK_RESULT $? 0 0 "qpdf --underlay running failed"
    qpdf ./common/infile.pdf --underlay ./common/stamp.pdf --to=1-3 --from=1 --repeat=1 -- output10.pdf && test -f output10.pdf
    CHECK_RESULT $? 0 0 "qpdf --underlay options running failed"
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
