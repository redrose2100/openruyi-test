#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/08.08
# @License   :   Mulan PSL v2
# @Desc      :   pdfinfo functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "poppler-utils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pdfinfo -h
    CHECK_RESULT $? 0 0 "Pdfinfo command failed to view help manual"
    pdfinfo test.pdf | grep "WPS"
    CHECK_RESULT $? 0 0 "Pdfinfo command failed to match PDF file information"
    pdfinfo -isodates test.pdf | grep "CTS"
    CHECK_RESULT $? 0 1 "The pdfinfo command failed to print the date in ISO-8601 format"
    pdfinfo -dests test.pdf | grep "Name"
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
    pdfinfo -listenc test.pdf | grep "UTF-8"
    CHECK_RESULT $? 0 0 "The pdfinfo command does not support UTF-8 format encoding"
    pdfinfo -v
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to query version information"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


