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
    DNF_INSTALL "wsmancli openwsman-server docker"
    docker run -d -it --rm -p 0.0.0.0:5988:5988 -p 0.0.0.0:5989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    # if not sleep First two script always fail because of connect faild
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test command: wseventmgr
    # SYNOPSIS: wseventmgr [-h -P -u -p -x -D -Z -b -d -j -c -A -K -g]
    # test -h -P -u -p -x -D -Z we put these for one script because of it dose not work if less one paramter ,so follow script would base it
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -h localhost -P 5985 -u wsman -p wsman | grep "<wse:SubscribeResponse>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -h -P -u -p -x -D -Z"
    # test option: -b use -b url represent -h -P -u -p for login wsmanserver
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman | grep "<wse:SubscribeResponse>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -b"
    # test option: -d
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -d 1 2>&1 | grep "HTTP"
    CHECK_RESULT $? 1 0 "wamancli.wseventmgr: faild to test option -d"
    # level 4 generate detail log
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -d 4 2>&1 | grep "HTTP"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -d"
    # test option: -j
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -j GBK | grep '<?xml version="1.0" encoding="GBK"?>'
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -j"
    # test option: -c
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -c common/my.cert | grep "<wse:Identifier>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -c"
    # test option: -A
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -A common/my.cert 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -A"
    # test option: -K
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -K common/my,cert 2>&1 | grep "cert"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -K"
    # test option: -g
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -g wsman | grep "<wsa:Address>http://localhost:5985/wsman</wsa:Address>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -g"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd
    kill -9 $(pgrep openwsmand)
    docker stop openpegasus
    DNF_REMOVE
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
