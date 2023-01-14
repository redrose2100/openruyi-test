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
    openjade -b utf-8 -e null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -e failed"
    openjade -b utf-8 --open-entities null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --open-entities failed"
    openjade -b utf-8 -g null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -g failed"
    openjade -b utf-8 --open-elements null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --open-elements failed"
    openjade -b utf-8 -n null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -n failed"
    openjade -b utf-8 --error-numbers null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --error-numbers failed"
    openjade -b utf-8 -x -f ./error.log -n null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -x failed"
    openjade -b utf-8 --references -f ./error.log -n null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --references failed"
    openjade -t sgml -i html -d null.dsl#html null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -i failed"
    openjade -t sgml --include html -d null.dsl#html null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --include failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf error.*
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
