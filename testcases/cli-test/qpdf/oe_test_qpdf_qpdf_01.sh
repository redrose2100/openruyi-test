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

source "${OET_PATH}"/libs/locallibs/common_lib.sh
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
    version=$(qpdf -version)
    version=${version#*qpdf version }      
    rpm -qa| grep qpdf | grep "${version%Run*}"
    CHECK_RESULT $? 0 0 "qpdf --version running failed"
    qpdf --copyright | grep "Copyright (c)"
    CHECK_RESULT $? 0 0 "qpdf --copyright running failed"
    qpdf --help | grep "help"
    CHECK_RESULT $? 0 0 "qpdf --help running failed"
    qpdf --completion-bash | grep "complete"
    CHECK_RESULT $? 0 0 "qpdf --completion-bash running failed"
    qpdf --completion-zsh | grep "autoload"
    CHECK_RESULT $? 0 0 "qpdf --completion-zsh running failed"
    qpdf --password=123456 ./common/encrypt.pdf - | grep "startxref"
    CHECK_RESULT $? 0 0 "qpdf --password=password running failed"
    qpdf --verbose --empty ./temp/output.pdf | grep "wrote"
    CHECK_RESULT $? 0 0 "qpdf --verbose running failed"
    qpdf --progress --empty ./temp/output.pdf | grep "write progress"
    CHECK_RESULT $? 0 0 "qpdf --progress running failed"
    qpdf --no-warn --check ./common/warn.pdf 2>&1 | grep -i "warning"
    CHECK_RESULT $? 1 0 "qpdf -no-warn running failed"
    qpdf --linearize ./common/infile.pdf - | grep "EOF"
    CHECK_RESULT $? 0 0 "qpdf --linearize running failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf temp
    LOG_INFO "End to restore the test environment."
}

main "$@"
