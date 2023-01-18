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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of openjade command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openjade
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    jade -b utf-8 -e common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade -e failed"
    jade -b utf-8 --open-entities common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade --open-entities failed"
    jade -b utf-8 -g common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade -g failed"
    jade -b utf-8 --open-elements common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade --open-elements failed"
    jade -b utf-8 -n common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade -n failed"
    jade -b utf-8 --error-numbers common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade --error-numbers failed"
    jade -b utf-8 -x -f ./error.log -n common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade -x failed"
    jade -b utf-8 --references -f ./error.log -n common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade --references failed"
    jade -t sgml -i html -d common/null.dsl#html common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade -i failed"
    jade -t sgml --include html -d common/null.dsl#html common/null.sgml
    CHECK_RESULT $? 0 0 "Check jade --include failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf error.* common/*.rtf common/*.fot common/*.xml common/error.*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
