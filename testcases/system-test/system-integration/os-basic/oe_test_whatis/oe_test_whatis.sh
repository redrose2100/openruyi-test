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
# @Author    :   xiongneng
# @Contact   :   xiongneng05@uniontech.com
# @Date      :   2023-02-06
# @License   :   Mulan PSL v2
# @Desc      :   whatis command test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    whatis -? |grep "version"
    CHECK_RESULT $? 0 0 "check display failed after whatis -?"
    whatis -V
    CHECK_RESULT $? 0 0 "check display failed after whatis -V"
    whatis man |grep -E "manuals|手册"
    CHECK_RESULT $? 0 0 "check display failed after whatis man"
    whatis lsattr | grep "lsattr"
    CHECK_RESULT $? 0 0 "check display failed after whatis ls"
    whatis -r ^lsat | grep "lsattr"
    CHECK_RESULT $? 0 0 "check display failed after whatis -r ^lsat"
    whatis -w lsat* | grep "lsattr"
    CHECK_RESULT $? 0 0 "check display failed after whatis -w lsat*"
    LOG_INFO "End to run test."
}

main "$@"
