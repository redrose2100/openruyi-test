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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ! jtidy -win1252 test/demo.html 2>&1 | grep '&mdash;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -win1252 "
    ! jtidy -big5 test/demo.html 2>&1 | grep '&mdash;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -big5 "
    ! jtidy -shiftjis test/demo.html 2>&1 | grep '&mdash;'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -shiftjis "
    jtidy -language en test/demo.html 2>&1 | grep 'lang=\"en\"'
    CHECK_RESULT $? 0 0 "Failed option: jtidy -language "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
