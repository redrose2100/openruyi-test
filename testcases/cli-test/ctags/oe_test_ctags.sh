#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/05.24
# @License   :   Mulan PSL v2
# @Desc      :   ctags functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ctags"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ctags --list-languages | grep -E 'Ant|Java|Basic|HTML'
    CHECK_RESULT $? 0 0 "Ctags failed to recognize language"
    ctags --list-maps |grep Python |grep '.*py.*pyx.*pxd.*pxi.*scons.*'
    CHECK_RESULT $? 0 0 "Failed to view default extension language"
    ctags --list-kinds |grep Python
    CHECK_RESULT $? 0 0 "Ctags failed to recognize Python language"
    ctags --list-kinds=Python | grep 'c  classes'
    CHECK_RESULT $? 0 0 "Failed to view recognizable Python syntax elements"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


