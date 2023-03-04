#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test asciidoctor
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "rubygem-asciidoctor"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ! asciidoctor -h 2>&1 | grep 'invalid option' && asciidoctor -h 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -h"
    ! asciidoctor -V 2>&1 | grep 'invalid option' && asciidoctor -V 2>&1 | grep 'Asciidoctor.*https://asciidoctor.org'
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -V"
    asciidoctor -b html test/demo.asciidoc && test -f test/demo.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -b"
    asciidoctor -d article test/demo_d.asciidoc && test -f test/demo_d.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -d"
    asciidoctor -e test/demo_e.asciidoc && test -f test/demo_e.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -e"
    asciidoctor -o test/demo_o.html test/demo.asciidoc && test -f test/demo_o.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -o"
    asciidoctor -R test/ test/demo_R.asciidoc && test -f test/demo_R.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -R"
    asciidoctor -S safe test/demo_S.asciidoc && test -f test/demo_S.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -S"
    asciidoctor -s test/demo_s.asciidoc && test -f test/demo_s.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -s"
    asciidoctor -n test/demo_n.asciidoc && test -f test/demo_n.html
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
