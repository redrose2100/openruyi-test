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
# @Date      :   2022/09/20
# @License   :   Mulan PSL v2
# @Desc      :   Test asciidoctor 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "rubygem-asciidoctor"
    tar -zxvf common/test.tar.gz
    gem install -l data/tilt-2.0.11.gem
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    asciidoctor -T test/ test/demo_d.asciidoc && test -f test/demo_d.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -T"
    asciidoctor -E tilt test/demo_e.asciidoc && test -f test/demo_e.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -E"
    asciidoctor -I /root/.local/share/gem test/demo_o.asciidoc && test -f test/demo_o.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -I"
    asciidoctor -D test/ test/demo_R.asciidoc && test -f test/demo_R.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -D"
    asciidoctor -r tilt test/demo_s.asciidoc && test -f test/demo_s.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -r"
    asciidoctor --failure-level INFO test/demo_S.asciidoc && test -f test/demo_S.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor --failure-level"
    asciidoctor -q test/demo_q.asciidoc && test -f test/demo_q.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -q"
    asciidoctor -a name[=value] test/demo.asciidoc && test -f test/demo.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -a"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    echo y | gem uninstall tilt 
    rm -rf test/ data/ 
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
