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
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    docker run -d -it --rm -p 0.0.0.0:5988:5988 -p 0.0.0.0:5989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wseventmgr
    # SYNOPSIS: wsman [-G -s -U --delivery-password -T -r --event-reference-properties -H -l -E]
    # test -G
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -G pull | grep '<wse:Delivery Mode="http://schemas.dmtf.org/wbem/wsman/1/wsman/Pull">'
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -G "
    # test -s
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -s httpbasic | grep '<wsman:Auth Profile="http://schemas.dmtf.org/wbem/wsman/1/wsman/secprofile/http/basic"/>'
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -s "
    # test -U --delivery-password only -U it dose not work --delivery-password -P is conflict because -P also represent port
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -s httpbasic -U testname --delivery-password testpass | grep "<n2:UsernameToken>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -U --delivery-password"
    # test -T
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -T AAAA| grep '<wsman:CertificateThumbprint>AAAA</wsman:CertificateThumbprint>'
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -T "
    # test -r -r, --subscription-expiry-time=<seconds> subscription expiry time in seconds
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -r 600 | grep "<wse:Expires>PT600.000000S</wse:Expires>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -r"
    # test -r --event-reference-properties=<xml string> this -r conflict with top
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R --event-reference-properties '<test/>' | grep '<wsa:ReferenceProperties>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test --event-reference-properties"
    # test -H -R with -R will print the request about -H param
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -H 10 | grep "<wsman:Heartbeats>PT10.000000S</wsman:Heartbeats>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -H -R"
    # test -l
    wseventmgr subscribe http://schemas.dmtf.org/wbem/wscim/1/* -x "SELECT * FROM CIM_ProcessIndication" -D "http://schemas.microsoft.com/wbem/wsman/1/WQL" -Z http://127.0.0.1:80/eventsink -b http://wsman:wsman@localhost:5985/wsman -R -l | grep "<wsman:SendBookmarks/>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -l "
    # test -E
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -E
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr:: faild to test -E"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep openwsmand)
    rm -rf /etc/openwsman/test_simple_auth.passwd
    docker stop openpegasus
    DNF_REMOVE
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
