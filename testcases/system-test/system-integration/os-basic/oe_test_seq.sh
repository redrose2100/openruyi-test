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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2023.7.26
# @License   :   Mulan PSL v2
# @Desc      :   Seq formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# Run the test
function run_test() {
    LOG_INFO "Start to run test."
    seq 3
    CHECK_RESULT $? 0 0 "seq default print error"
    res1=$(seq -s " " 5)
    [ "$res1" == "1 2 3 4 5" ]
    CHECK_RESULT $? 0 0 "seq -s print error"
    res2=$(seq -s " " -w 98 101)
    [ "$res2" == "098 099 100 101" ]
    CHECK_RESULT $? 0 0 "seq -w print error"
    LOG_INFO "End to run test."
}

main "$@"

