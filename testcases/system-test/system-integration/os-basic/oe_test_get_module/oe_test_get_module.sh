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
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-12-18
# @License   :   Mulan PSL v2
# @Desc      :   获取模块信息-get_module
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    modinfo kvm|grep sig
    CHECK_RESULT $? 0 1 "modinfo function error"
    modinfo kvm|grep parm
    CHECK_RESULT $? 0 0 "modinfo function error"
    modinfo drm|grep sig
    CHECK_RESULT $? 0 1 "modinfo function error"
    modinfo drm|grep parm
    CHECK_RESULT $? 0 0 "modinfo function error"
    modinfo nfnetlink|grep sig
    CHECK_RESULT $? 0 0 "modinfo function error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
