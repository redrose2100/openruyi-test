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
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli openwsman-server docker"
    docker run -d -it --rm -p 0.0.0.0:5988:5988 -p 0.0.0.0:5989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-x -D -Z -G -s -n -z --delivery-thumbprint -r -H -l]
    # test -x -D -Z we put these for one script because of it dose not work if less one paramter ,so follow script would base it
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman | grep "<wse:SubscribeResponse>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -x -D -Z"
    # test -G
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R -G pull | grep '<wse:Delivery Mode="http://schemas.dmtf.org/wbem/wsman/1/wsman/Pull">'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -G "
    # test -s
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R -s httpbasic | grep '<wsman:Auth Profile="http://schemas.dmtf.org/wbem/wsman/1/wsman/secprofile/http/basic"/>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -s "
    # test -n -z only -n it dose not work
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R -s httpbasic -n testname -z testpass | grep "<n2:UsernameToken>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -n -z "
    # test --delivery-thumbprint in usage, -Y == --delivery-thumbprint but -Y conflict with --proxyauth=<proxyauth>
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R --delivery-thumbprint AAA | grep "<wsman:CertificateThumbprint>AAA</wsman:CertificateThumbprint>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test --delivery-thumbprint"
    # test -r
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -r 600 | grep "<wse:Expires>PT600.000000S</wse:Expires>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -r"
    # test -H -R with -R will print the request about -H param
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R -H 10 | grep "<wsman:Heartbeats>PT10.000000S</wsman:Heartbeats>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -H -R"
    # test -l
    wsman subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -h localhost -u wsman -p wsman -R -l | grep "<wsman:SendBookmarks/>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -l "
    LOG_INFO "End to run test."
}

function post_test() {
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
