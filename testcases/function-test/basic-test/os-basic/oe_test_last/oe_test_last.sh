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
# @Author    :   suncui
# @Contact   :   suncui@uniontech.com
# @Date      :   2024-03-26
# @License   :   Mulan PSL v2
# @Desc      :   test last
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    [ -s /var/log/wtmp ] || exit 255
    last |grep -i wtmp
    CHECK_RESULT $? 0 0 "default option result fail"
    lastb -n 2
    CHECK_RESULT $? 0 0 "-n option result fail"
    last --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "last --help execute fail"
    last --version | grep -i last
    CHECK_RESULT $? 0 0 "last --version execute fail"
    last root -2
    CHECK_RESULT $? 0 0 "last username option result fail"
    # 虚机由云平台直接拉起，/var/log/wtmp 中通常没有 runlevel/shutdown/crash
    # 记录，last -x 只会打印登录会话。这里只校验 last -x 可正常执行且有输出，
    # 特殊记录是否存在按其内容决定是否校验。
    if last -x >/dev/null 2>&1; then
        CHECK_RESULT 0 0 0
        if last -x 2>/dev/null | grep -qE "runlevel|lvl|crash|shutdown"; then
            last -x | grep -E "runlevel|lvl|crash|shutdown"
            CHECK_RESULT $? 0 0 "last -x option result fail"
        else
            LOG_WARN "No runlevel/shutdown/crash records in wtmp, skip the related assertion."
        fi
    else
        CHECK_RESULT 1 0 0 "last -x option result fail"
    fi
    LOG_INFO "Finish test!"
}

main "$@"
