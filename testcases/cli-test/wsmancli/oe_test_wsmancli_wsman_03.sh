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

source ${OET_PATH}/libs/locallibs/common_lib.sh
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
    # SYNOPSIS: wsman [-O,-V,-v,-I]
    # test option: -O
    wsman identify -h localhost --port 5985 -u wsman --password wsman -O outfile.out
    test -f outfile.out
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -O"
    # test option: -V
    wsman invoke http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_JobQueue -h localhost --port 5985 -u wsman --password wsman -a service -d 6 -V 2>&1 | grep "cl->authentication.verify_peer: 0"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -V"
    # test option: -v
    wsman identify -h localhost --port 5985 -u wsman --password wsman -v -d 6 2>&1 | grep verify
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -v"
    # test option: -I after 3 sceconds get a fail message
    wsman identify -h www.baidu.com --port 5985 -u wsman --password wsman -I 3 -d 6 2>&1 | grep "Connection timed out"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -I"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf outfile.out /etc/openwsman/test_simple_auth.passwd
    kill -9 $(pgrep openwsmand)
    DNF_REMOVE
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
