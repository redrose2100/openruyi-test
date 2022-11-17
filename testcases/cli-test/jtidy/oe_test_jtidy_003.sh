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
    ! jtidy -f tmp/errors test/demo_error.html && ls tmp 2>&1 | grep 'errors'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -f "
    jtidy -raw test/demo.html 2>&1 | grep '&mdash;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -raw "
    jtidy -ascii test/demo.html 2>&1 | grep '&mdash;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -ascii "
    ! jtidy -latin1 test/demo.html 2>&1 | grep '&frac12;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -latin1 "
    jtidy -iso2022 test/demo.html 2>&1 | grep '\!\='
    CHECK_RESULT $? 0 0 "Failed option: jtidy -iso2022 "
    jtidy -utf8 test/demo.html 2>&1 | grep '\½'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -utf8 "
    jtidy -mac test/demo_m.html 2>&1 | grep 'missing.*title.*element'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -mac "
    jtidy -utf16le test/demo.html 2>&1 | grep 'HTML 3.2'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16le "
    jtidy -utf16be test/demo.html 2>&1 | grep 'HTML 3.2'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16be "
    jtidy -utf16 test/demo.html 2>&1 | grep 'HTML 3.2'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16 "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf tmp test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
