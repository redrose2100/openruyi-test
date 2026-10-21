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
#@Desc      	:   Test zlib-flate and fix-qdf
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
    zlib-flate -compress < ./common/infile.pdf > compress.pdf && test -f compress.pdf
    CHECK_RESULT $? 0 0 "zlib-flate command options -compress running failed"
    zlib-flate -uncompress < compress.pdf > uncompress.pdf && test -f uncompress.pdf
    CHECK_RESULT $? 0 0 "zlib-flate command options -uncompress running failed"
    qpdf -qdf ./common/infile.pdf qpf.pdf
    fix-qdf qpf.pdf | grep "Original object ID"
    CHECK_RESULT $? 0 0 "fix-qdf command running failed"
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