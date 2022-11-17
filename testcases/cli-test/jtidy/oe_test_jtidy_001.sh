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
    jtidy -v 2>&1 | grep 'JTidy released'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -v"
    ! jtidy -h 2>&1 | grep 'unrecognized option' && jtidy -h 2>&1 | grep 'Tidy.*option.*file'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -h "
    jtidy -i test/demo.html 2>&1 | grep '  <head>'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -i "
    ! jtidy -o test/demo.html 2>&1 | grep '</p>'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -o "
    ! jtidy -wrap 4 test/demo.html 2>&1 | grep '<html lang="en">'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -wrap "
    jtidy -config test/config test/demo.html | grep '  <head>'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -config "
    jtidy -i -show-config test/demo.html 2>&1 | grep 'indent.*Indent.*true'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -show-config "
    jtidy -u test/demo.html 2>&1 | grep '<HEAD>'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -u "
    jtidy -c test/demo.html 2>&1 | grep 'text/css'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -c "
    jtidy -b test/demo.html 2>&1 | grep '\-\-'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -b "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
