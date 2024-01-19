#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2024/01/10
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
    pdfinfo -f 1  test.pdf | grep "Title"
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
    pdfinfo -l 2  test.pdf | grep "WPS"
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
    pdfinfo -box  test.pdf | grep "MediaBox"
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
    pdfinfo -rawdates  test.pdf | grep "CreationDate"
    CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


