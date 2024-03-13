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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2024.3.11
# @License   :   Mulan PSL v2
# @Desc      :   nice formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    nice sleep 30 &
    CHECK_RESULT $? 0 0 "nice set error"
    ps -l |awk '$13==sleep'|awk '$8==10'
    CHECK_RESULT $? 0 0 "nice set error"
    nice -n 19 sleep 30 &
    CHECK_RESULT $? 0 0 "nice set error"
    ps -l |awk '$13==sleep'|awk '$8==19'
    CHECK_RESULT $? 0 0 "nice set error"
    LOG_INFO "End to run test."
}

main "$@"