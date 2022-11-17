#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaorong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/09/19
# @License   :   Mulan PSL v2
# @Desc      :   Test cleancss
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rubygem-asciidoctor
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ! asciidoctor -h 2>&1 | grep 'invalid option' && asciidoctor -h 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -h"
    ! asciidoctor -V 2>&1 | grep 'invalid option' && asciidoctor -V 2>&1 | grep 'Asciidoctor.*https://asciidoctor.org'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -V"
    asciidoctor -b html test/demo.asciidoc && ls test 2>&1 | grep 'demo.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -b"
    asciidoctor -d article test/demo_d.asciidoc 2>&1 && ls test | grep 'demo_d.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -d"
    asciidoctor -e test/demo_e.asciidoc 2>&1 && ls test | grep 'demo_e.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -e"
    asciidoctor -o test/demo_o.html test/demo.asciidoc && ls test | grep 'demo_o.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -o"
    asciidoctor -R test/ test/demo_R.asciidoc && ls test | grep 'demo_R.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -R"
    asciidoctor -S safe test/demo_S.asciidoc && ls test | grep 'demo_S.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -S"
    asciidoctor -s test/demo_s.asciidoc && ls test | grep 'demo_s.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -s"
    asciidoctor -n test/demo_n.asciidoc && ls test | grep 'demo_n.html'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -n"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test/ data/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
