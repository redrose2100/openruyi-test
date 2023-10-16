#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-08-25
# @License   :   Mulan PSL v2
# @Desc      :   test sysstat packages
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "sysstat"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl start sysstat
    CHECK_RESULT $? 0 0 "sysstat service start failed"
    sar --help | grep -E 'Usage|用法'
    CHECK_RESULT $? 0 0 "sar --help failed"
    sar | grep CPU
    CHECK_RESULT $? 0 0 "sar command failed"
    sar -u -o testcpulog 5 3 | grep CPU | grep user
    CHECK_RESULT $? 0 0 "sar -u -o failed"
    test -f testcpulog
    CHECK_RESULT $? 0 0 "not found testcpulog"
    sar -r -o testmemlog 5 3 | grep kbmemfree | grep kbmemused
    CHECK_RESULT $? 0 0 "sar -r -o failed"
    test -f testmemlog
    CHECK_RESULT $? 0 0 "not found testmemlog"
    sar -b -o testiolog 5 3 | grep tps | grep rtps
    CHECK_RESULT $? 0 0 "sar -b -o failed"
    test -f testiolog
    CHECK_RESULT $? 0 0 "not found testiolog"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf test*log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
