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
# @Date      :   2023/07.10
# @License   :   Mulan PSL v2
# @Desc      :   texlive functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "texlive"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep texlive
    CHECK_RESULT $? 0 0 "Texlive installation failed"
    latex sample2e.tex
    CHECK_RESULT $? 0 0 "Command execution failed"
    test -f sample2e.aux && test -f sample2e.dvi && test -f sample2e.log
    CHECK_RESULT $? 0 0 "File generation failed"
    pdftex sample2e.tex << EOF
R
EOF
    test -f sample2e.pdf
    CHECK_RESULT $? 0 0 "File generation failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf sample2e.tex sample2e.aux sample2e.dvi sample2e.log sample2e.pdf
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


