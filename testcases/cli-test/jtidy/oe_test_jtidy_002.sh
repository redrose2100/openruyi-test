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
# @Author    :   huangdaohong
# @Contact   :   310809690@qq.com
# @Date      :   2022/09/19
# @License   :   Mulan PSL v2
# @Desc      :   Test jtidy
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL jtidy
    tar -zxvf test.tar.gz
    mkdir tmp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    jtidy -help-config | grep 'Name.*Typ.*Allowable values'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -help-config "
    jtidy -n test/demo.html 2>&1 | grep '\&\#189\;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -n "
    ! jtidy -e test/demo.html 2>&1 | grep 'Hello world'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -e "
    ! jtidy -q test/demo.html 2>&1 | grep 'no warnings or errors were found'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -q "
    jtidy -asxml test/demo.html 2>&1 | grep 'xhtml'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -asxml "
    jtidy -asxhtml test/demo.html 2>&1 | grep 'xhtml'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -asxhtml "
    jtidy -xml test/demo.xml 2>&1 | grep 'xhtml'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -xml "
    jtidy -ashtml test/demo.xhtml 2>&1 | grep '  <head>'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -ashtml "
    jtidy -slides test/demo.html 2>&1 | grep '2 Slides found'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -slides "
    jtidy -m test/demo_m.html 2>&1 | grep 'missing .*title'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -slides "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp slide*.html test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
