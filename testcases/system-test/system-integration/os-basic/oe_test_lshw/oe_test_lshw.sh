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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2024-2-4
# @License   :   Mulan PSL v2
# @Desc      :   command lshw
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lshw -version
    CHECK_RESULT $? 0 0 "show lshw version fail"
    lshw -html | grep version
    CHECK_RESULT $? 0 0 "show hardware info with html format fail"
    lshw -json | grep capabilities
    CHECK_RESULT $? 0 0 "show hardware info with json format fail"
    lshw -xml | grep version
    CHECK_RESULT $? 0 0 "show hardware info with xml format fail"
    lshw -short | grep -A 5 Description
    CHECK_RESULT $? 0 0 "show hardware info with brief mode fail "
    lshw -businfo | grep -A 5 Description
    CHECK_RESULT $? 0 0 "show bus info fail"
    lshw -c memory | grep -A 5 memory
    CHECK_RESULT $? 0 0 "show memory info fail"
    lshw -c cpu | grep -A 5 cpu
    CHECK_RESULT $? 0 0 "show cpu info fail"
    if [ "$(uname -m)" == "riscv64" ]; then
        lshw -c disk | grep -A 5 virtio1
        CHECK_RESULT $? 0 0 "show disk info fail"
    else
    	lshw -c disk | grep -A 5 disk
        CHECK_RESULT $? 0 0 "show disk info fail"
    fi
    LOG_INFO "End to run test."
}

main "$@"
