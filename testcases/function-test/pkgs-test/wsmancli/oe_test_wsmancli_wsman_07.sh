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
# shellcheck disable=SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "wsmancli openwsman-server docker"
    mv -rf /etc/docker/daemon.json /etc/docker/daemon-old.json
    echo '{
        "registry-mirrors":[
                "https://docker.nju.edu.cn",
                "https://docker.m.daocloud.io",
                "https://dockerproxy.com",
                "https://docker.mirrors.ustc.edu.cn",
                "https://docker.1panel.live",
                "https://hub.rat.dev",
                "https://docker.actima.top",
                "https://docker.1ms.run",
                "https://dockeraityp.com",
                "https://dockerhub.xisoul.cn",
                "https://docker.imgdb.be"
        ]
}
' >/etc/docker/daemon.json
    systemctl restart docker
    docker run -d -it --rm -p 0.0.0.0:5988:5988 -p 0.0.0.0:5989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    # if not sleep First two script always fail because of connect faild
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-m -o -E -M -U -i -g -k]
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        # test -m
        wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -m 1000 | grep "<wsen:MaxElements>1000</wsen:MaxElements>"
        CHECK_RESULT $? 0 0 "wamancli: faild to test -m"
    fi
    # test -o
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -o | grep "<wsman:OptimizeEnumeration/>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -o"
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        # test -E
        wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -E | grep "<wsman:TotalItemsCountEstimate>1</wsman:TotalItemsCountEstimate>"
        CHECK_RESULT $? 0 0 "wamancli: faild to test -E"
    fi
    # test -M
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -M epr | grep "<wsman:EnumerationMode>EnumerateEPR</wsman:EnumerationMode>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -M"
    # test -U
    wsman pull http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_Process -h localhost --port 5985 -u wsman --password wsman -R -U 12345 2>&1 | grep "<wsen:EnumerationContext>12345</wsen:EnumerationContext>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -M"
    # test -T
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_OperatingSystem -h localhost --port 5985 -u wsman --password wsman -R -T | grep '<wsman:Option Name="ShowExtensions"/>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -T"
    # test option: -i
    wsman unsubscribe -i 123123 -u wsman -p wsman -R 2>&1 | grep "<wse:Identifier>123123</wse:Identifier>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -i"
    # test -g
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -g aaa -R | grep '<wsa:To s:mustUnderstand="true">http://localhost:5985/aaa</wsa:To>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -g"
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        # test -k
        wsman create http://schema.openpegasus.org/wbem/wscim/1/cim-schema/2/PG_TestPropertyTypes -h localhost --port 5985 -u wsman --password wsman -R -N test/static -k PG_TestPropertyTypes.CreationClassName=qwe -J common/Create_Success01.xml
        CHECK_RESULT $? 0 0 "wamancli: faild to test -k"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd
    kill -9 $(pgrep openwsmand)
    docker stop openpegasus
    mv -rf /etc/docker/daemon-old.json /etc/docker/daemon.json
    DNF_REMOVE "$@"
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
