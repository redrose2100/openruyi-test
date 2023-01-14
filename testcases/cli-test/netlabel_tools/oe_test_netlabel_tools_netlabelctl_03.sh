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
# @Desc      :   verify the uasge of nasm command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL netlabel_tools
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test"
    netlabelctl mgmt protocols 2>&1 | grep 'UNLABELED'
    CHECK_RESULT $? 0 0 "Check netlabelctl mgmt protocols failed"
    netlabelctl calipso add pass doi:11
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso add pass failed"
    netlabelctl calipso del doi:11
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso del failed"
    netlabelctl calipso add pass doi:11
    netlabelctl calipso list 2>&1 | grep '11'
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso list failed"
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    netlabelctl calipso del doi:11
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
