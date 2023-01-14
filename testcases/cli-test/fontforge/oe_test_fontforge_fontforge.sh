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
# @Desc      :   verify the uasge of fontforge command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL fontforge
    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fontforge -help | grep "fontforge \[options\]"
    CHECK_RESULT $? 0 0 "Check fontforge -help failed"
    fontforge -version 2>&1 | grep -E "Version:.[0-9]{1,}"
    CHECK_RESULT $? 0 0 "Check fontforge -version failed"
    fontforge -docs 2>&1 | grep "fontforge \[options\]"
    CHECK_RESULT $? 0 0 "Check fontforge -docs failed"
    fontforge -script common/test.sh common/Duera-CondBlac-PERSONAL.ttf 2>&1 | grep 'License GPLv3+'
    CHECK_RESULT $? 0 0 "Check fontforge -script failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
