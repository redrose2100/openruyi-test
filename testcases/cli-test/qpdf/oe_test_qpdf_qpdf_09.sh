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
    mkdir temp
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    qpdf --linearize ./common/infile.pdf ./temp/linear.pdf
    qpdf --show-linearization ./temp/linear.pdf | grep "Page"
    CHECK_RESULT $? 0 0 "qpdf --show-linearization running failed"
    qpdf -show-xref ./common/infile.pdf | grep "offset"
    CHECK_RESULT $? 0 0 "qpdf --show-xref running failed"
    qpdf --show-object=trailer ./common/infile.pdf | grep "ID"
    CHECK_RESULT $? 0 0 "qpdf --show-object running failed"
    qpdf --show-object=1 --raw-stream-data ./common/infile.pdf | grep "Type"
    CHECK_RESULT $? 0 0 "qpdf --raw-stream-data running failed"
    qpdf --show-object=1 --filtered-stream-data ./common/infile.pdf | grep "Type"
    CHECK_RESULT $? 0 0 "qpdf --filtered-stream-data running failed"
    qpdf --show-npages ./common/infile.pdf
    CHECK_RESULT $? 0 0 "qpdf --show-npages running failed"
    qpdf --show-pages ./common/infile.pdf | grep "page"
    CHECK_RESULT $? 0 0 "qpdf --show-pages running failed"
    qpdf --show-pages --with-images ./common/infile.pdf | grep "page"
    CHECK_RESULT $? 0 0 "qpdf --show-pages -with-images running failed"
    qpdf --check ./common/infile.pdf | grep "Version"
    CHECK_RESULT $? 0 0 "qpdf --check running failed"
    qpdf --json ./common/infile.pdf | grep "version"
    CHECK_RESULT $? 0 0 "qpdf --json running failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE 
    rm -rf temp
    LOG_INFO "End to restore the test environment."
}

main "$@"