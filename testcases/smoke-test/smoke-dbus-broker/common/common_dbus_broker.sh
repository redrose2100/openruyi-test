#!/usr/bin/bash
  
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-11-16
#@License       :   Mulan PSL v2
#@Desc          :   dbus-broker func
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# usage: check service status
# input: $1: service list
#        $2: sleep interval(sec), default 1s
#        $3: max wait(sec), default 3s
# output: null
function check_status() {
    local services="$1"
    local interval="${2:-1}"
    local round="${3:-3}"
    local cnt

    for ((cnt = 0; cnt < "${round}"; cnt += "${interval}")); do
        sleep "${interval}"
        systemctl status --no-pager --full "${services}" && return 0
    done
    add_failure "check service status: ${services}"
    return 1
}
