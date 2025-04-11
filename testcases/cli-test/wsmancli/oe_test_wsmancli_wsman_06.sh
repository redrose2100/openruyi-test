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
    # SYNOPSIS: wsman [-R -S -N -B -t -e -E -F -L]
    # test -R if -R will get request detail
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R | grep "<wsen:Pull>"
        CHECK_RESULT $? 0 0 "wamancli: faild to test -R"
    fi
    # test -S if -S will could not get final result so if grep the information represent fail
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -S | grep "<n1:CreationClassName>PG_ComputerSystem</n1:CreationClassName>"
    CHECK_RESULT $? 1 0 "wamancli: faild to test -S"
    # test -N
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -N smash/ipmi 2>&1 | grep "CIM_ERR_INVALID_NAMESPACE: smash/ipmi"
        CHECK_RESULT $? 0 0 "wamancli: faild to test -N"
    fi
    # test -B
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -B exclude | grep "<wsmb:PolymorphismMode>ExcludeSubClassProperties</wsmb:PolymorphismMode>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -B"
    # test -t
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -t 5000 | grep "<wsman:OperationTimeout>PT5.0S</wsman:OperationTimeout>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -t"
    # test -e
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -e 4 | grep "<wsman:MaxEnvelopeSize>4</wsman:MaxEnvelopeSize>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test -e"
    # test -F
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -F TEST_F | grep '<wsman:FragmentTransfer s:mustUnderstand="true">TEST_F</wsman:FragmentTransfer>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -F"
    # test -L
    wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ComputerSystem -h localhost --port 5985 -u wsman --password wsman -R -L TEST_L | grep '<wsman:Locale xml:lang="TEST_L" s:mustUnderstand="false"/>'
    CHECK_RESULT $? 0 0 "wamancli: faild to test -L"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd
    kill -9 $(pgrep openwsmand)
    docker stop openpegasus
    mv -rf /etc/docker/daemon-old.json /etc/docker/daemon.json
    DNF_REMOVE "$@"
    # sleep 10 seconds prevent openwsmand be killed by last script
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
