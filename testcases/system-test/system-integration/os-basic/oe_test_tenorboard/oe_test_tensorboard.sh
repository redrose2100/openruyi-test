#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023.04.20
# @License   :   Mulan PSL v2
# @Desc      :   File system common command tensorboard
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
TESTCASE_LEVEL=2
APPLY_BRANCH=e
function pre_test()
{
    LOG_INFO "pre test"
    DNF_INSTALL "python3-tensorflow"
}

function do_test()
{
    LOG_INFO "do test"
    if [ "x${PRODUCT}" == "xenterprisec" ];then
        exit 0
    fi
    python3 740429.py
    CHECK_RESULT $? 0
}

function post_test()
{
    LOG_INFO "post test"
    DNF_REMOVE
}
main $@
