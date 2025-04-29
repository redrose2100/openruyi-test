#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/1/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "netdata" command
###################################

# shellcheck disable=SC1091
# shellcheck disable=SC2046
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    addr=$(
        cd "$(dirname "$0")" || exit 1
        pwd
    )
    name="/test.txt"
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL netdata
    touch test.txt
    mkdir -p /var/lib/netdata/cloud.d
    touch /var/lib/netdata/cloud.d/cloud.conf
    chown -R netdata:netdata /var/lib/netdata/cloud.d
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_netdata."
    systemctl start netdata
    CHECK_RESULT $? 0 0 "Failed : start"
    systemctl restart netdata
    CHECK_RESULT $? 0 0 "Failed : restart"
    systemctl status netdata | grep "running"
    CHECK_RESULT $? 0 0 "Failed : status"
    systemctl stop netdata
    CHECK_RESULT $? 0 0 "Failed : stop"
    netdata -v 2>&1 | grep "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed option: -v"
    netdata -c /etc/netdata/netdata.conf 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -c filename"
    SLEEP_WAIT 3
    kill -9 $(pgrep -f "netdata -c")
    SLEEP_WAIT 3
    netdata -d 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -d"
    kill -9 $(pgrep -f "netdata -d")
    SLEEP_WAIT 3
    netdata -h 2>&1 | grep "SYNOPSIS"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    netdata -P "$addr"$name 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -P"
    exc=$(cat test.txt)
    pgrep -a "netdata" | awk -F " " '{print$1}' 2>&1 | grep "${exc}"
    CHECK_RESULT $? 0 0 "Failed option: -P"
    kill -9 $(pgrep -f "netdata -P")
    SLEEP_WAIT 3
    netdata -i "$NODE1_IPV4" 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -i IP"
    kill -9 $(pgrep -f "netdata -i")
    SLEEP_WAIT 3
    netdata -p 19999 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -p"
    kill -9 $(pgrep -f "netdata -p")
    SLEEP_WAIT 3
    netdata -t 1 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -t"
    kill -9 $(pgrep -f "netdata -t")
    SLEEP_WAIT 3
    netdata -u netdata 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -u"
    kill -9 $(pgrep -f "netdata -u")
    SLEEP_WAIT 3
    netdata -s / 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -s"
    kill -9 $(pgrep -f "netdata -s")
    SLEEP_WAIT 3
    netdata -V 2>&1 | grep "[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed option: -V"
    netdata -W stacksize=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W stacksize=N"
    kill -9 $(pgrep -f "netdata -W")
    SLEEP_WAIT 3
    netdata -W debug_flags=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W debug_flags=N"
    kill -9 $(pgrep -f "netdata -W")
    SLEEP_WAIT 3
    netdata -W unittest 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W unittest"
    netdata -W createdataset=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W createdataset=N"
    netdata -W set section option value 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W set section option value"
    netdata -W simple-pattern pattern string | grep "RESULT"
    CHECK_RESULT $? 0 0 "Failed option: -W simple-pattern pattern string"
    kill -9 $(pgrep -f "netdata -W")
    ./killpid.sh &
    SLEEP_WAIT 2
    netdata -D 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -D"
    LOG_INFO "End to run testcase:oe_test_netdata."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    kill -9 $(pgrep -l "netdata")
    rm -rf test.txt /var/lib/netdata/cloud.d
    LOG_INFO "End to restore the test environment."
}

main "$@"
