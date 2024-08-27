#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   chenzirui
# @Contact   :   ziruichen@126.com
# @Date      :   2022/10/01
# @License   :   Mulan PSL v2
# @Desc      :   Test wsmancli
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli openwsman-server"
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-q,--non-interactive,-d,-j,-c,-A,-K,-u,-J]
    # test option: -q
    wsman -q | grep wsmancli
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -q"
    # test option: --non-interactive if not --non-interactive you should retype correct username and password
    wsman identify -h localhost --port 5985 -u wsman --password wsmanerr --non-interactive 2>&1 | grep "Login denied"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option --non-interactive"
    # test option: -d
    wsman identify -h localhost --port 5985 -u wsman --password wsman -d 1 | grep "HTTP"
    CHECK_RESULT $? 1 0 "wamancli: faild to test option -d"
    # level 4 generate detail log
    wsman identify -h localhost --port 5985 -u wsman --password wsman -d 4 2>&1 | grep "HTTP"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -d"
    # test option: -j
    wsman identify -h localhost --port 5985 -u wsman --password wsman -j GBK | grep '<?xml version="1.0" encoding="GBK"?>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -j"
    # test option: -c
    wsman identify -h localhost --port 5985 -u wsman --password wsman -c common/my.cert 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -c"
    # test option: -A
    wsman identify -h localhost --port 5985 -u wsman --password wsman -A common/my.cert 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -A"
    # test option: -K
    wsman identify -h localhost --port 5985 -u wsman --password wsman -K common/my.cert 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -K"
    # test option: -J
    wsman identify -h localhost --port 5985 -u wsman --password wsman -J common/my.cert
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -J"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd
    kill -9 "$(pgrep openwsmand)"
    DNF_REMOVE "$@"
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
