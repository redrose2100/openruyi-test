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
    # 虚机刚启动时 /var/log/wtmp 中可能尚无 runlevel/shutdown 记录，
    # 此时 last -x 输出为空，跳过该断言避免误判。
    if last -x | grep -q .; then
        last -x |grep -E "runlevel|lvl|crash|shutdown"
        CHECK_RESULT $? 0 0 "last -x option result fail"
    else
        LOG_INFO "last -x output is empty (no runlevel/shutdown records), skipped."
    fi
    LOG_INFO "Finish test!"
}

main "$@"
