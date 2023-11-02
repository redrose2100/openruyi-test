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
# @Date      :   2023-11-02
# @License   :   Mulan PSL v2
# @Desc      :   verification ipmitool command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "ipmitool"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ipmitool help
    CHECK_RESULT $? 0 0 "ipmitool -help failed"
    ipmitool sel elist
    CHECK_RESULT $? 0 0 "sel elist failed"
    ipmitool sel clear
    CHECK_RESULT $? 0 0 "sel clear failed"
    ipmitool sel time get
    CHECK_RESULT $? 0 0 "sel time get failed"
    ipmitool sensor list
    CHECK_RESULT $? 0 0 "sensor list"
    ipmitool mc info
    CHECK_RESULT $? 0 0 "mc info failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
