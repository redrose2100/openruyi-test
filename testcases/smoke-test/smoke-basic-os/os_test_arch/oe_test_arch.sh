#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   qinjiaxi
# @Contact   :   qinjiaxi@uniontech.com
# @Date      :   2024-04-03
# @License   :   Mulan PSL v2
# @Desc      :   test arch
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    arch
    CHECK_RESULT $? 0 0 "arch execute fail"
    arch --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "arch --help execute fail"
    arch --version | grep -i arch
    CHECK_RESULT $? 0 0 "arch --version execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
