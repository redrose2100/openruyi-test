#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

####################################
#@Author        :   wangjingfeng
#@Contact       :   1136232498@qq.com
#@Date          :   2020/12/22
#@License       :   Mulan PSL v2
#@Desc          :   freeradius command parameter automation use case
####################################

# shellcheck disable=SC2009
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL freeradius
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    radiusd -d /etc/raddb
    pgrep -f "radiusd -d" | grep -v grep
    CHECK_RESULT $? 0 0 "radiusd -d execution failed."
    kill -9 "$(pgrep -f "radiusd -d")"
    radiusd -D /usr/share/freeradius
    pgrep -f "radiusd -D" | grep -v grep
    CHECK_RESULT $? 0 0 "radiusd -D execution failed."
    kill -9 "$(pgrep -f "radiusd -D")"
    radiusd -f &
    SLEEP_WAIT 2
    pgrep -f "radiusd -f" | grep -v grep
    CHECK_RESULT $? 0 0 "radiusd -f execution failed."
    kill -9 "$(pgrep -f "radiusd -f")"
    radiusd -h | grep -i "usage"
    CHECK_RESULT $? 0 0 "radiusd -h execution failed."
    rdport=$(GET_FREE_PORT "$NODE1_IPV4")
    radiusd -i "$NODE1_IPV4" -p "${rdport}"
    pgrep -f "radiusd -i" | grep -v grep
    CHECK_RESULT $? 0 0 "radiusd -i -p execution failed."
    kill -9 "$(pgrep -f "radiusd -i")"
    radiusd -l /tmp/test.log
    pgrep -f "radiusd -l" | grep -v grep && [ -s /tmp/test.log ]
    CHECK_RESULT $? 0 0 "radiusd -l execution failed."
    kill -9 "$(pgrep -f "radiusd -l")"
    cp /etc/raddb/radiusd.conf /etc/raddb/test.conf
    radiusd -n test
    SLEEP_WAIT 5
    pgrep -f "radiusd -n" | grep -v grep
    CHECK_RESULT $? 0 0 "radiusd -n execution failed."
    kill -9 "$(pgrep -f "radiusd -n")"
    radiusd -P
    result1=$(cat /var/run/radiusd/radiusd.pid)
    SLEEP_WAIT 5
    result2=$(ps -ef |grep "radiusd -P" | grep -v grep | awk '{print $2}')
    echo "$result2"
    [ "${result1}" -eq "${result2}" ]
    CHECK_RESULT $? 0 0 "radiusd -P execution failed."
    kill -9 "${result2}"
    radiusd -s &
    [ "$(ps -ef | grep "radiusd -s" | grep -v grep | awk '{print $3}')" -ne 1 ]
    CHECK_RESULT $? 0 0 "radiusd -s execution failed."
    kill -9 "$(pgrep -f "radiusd -s")"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /etc/raddb
    rm -rf /var/log/radius
    rm -rf /tmp/test.log
    rm -rf /var/run/radiusd
    LOG_INFO "End to restore the test environment."
}

main "$@"
