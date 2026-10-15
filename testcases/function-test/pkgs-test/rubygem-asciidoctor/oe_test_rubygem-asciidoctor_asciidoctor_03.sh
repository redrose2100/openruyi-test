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
    DNF_INSTALL "rubygem-asciidoctor tar"
    tar -zxvf common/test.tar.gz
    gem install -l data/tilt-2.0.11.gem
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    asciidoctor -w test/demo_w.asciidoc && test -f test/demo_w.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -w"
    asciidoctor -t test/demo_t.asciidoc && test -f test/demo_t.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -t"
    asciidoctor -v test/demo_v.asciidoc && test -f test/demo_v.html
    CHECK_RESULT $? 0 0 "Failed option: asciidoctor -v"
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
