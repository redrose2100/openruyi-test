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
    cp common/simple_auth.passwd /etc/openwsman/test_simple_auth.passwd
    openwsmand -c common/openwsman.conf
    docker run \
     --name=ss5 \
     --hostname=ss5 \
     --network=host \
     --env=user=wsman \
     --env=passwd=wsman \
     --env=port=1080 \
     --volume=/etc/resolv.conf:/etc/resolv.conf \
     --restart=always \
     --detach=true \
     -t registry.cn-hangzhou.aliyuncs.com/dengdai/ss5:3.8.9
    # if not sleep First two script always fail because of connect faild
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test command: wsman
    # SYNOPSIS: wsman [-b,-P,-X,-Y,-y,-a,-C]
    # test option: -b
    wsman identify -b http://wsman:wsman@localhost:5985/wsman | grep "wsmid:IdentifyResponse"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -b"
    # test option: -P
    wsman identify -h localhost -P 5985 -u wsman -p wsman
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -P"
    # test option: -X -Y
    wsman identify -h 127.0.0.1 --port 5985 -u wsman --password wsman -X socks5://127.0.0.1:1080 -d 6 -v -Y wsman:wsman 2>&1 | grep "SOCKS5 request granted."
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -X -Y"
    # test option: -y
    wsman identify -h localhost --port 5985 -u wsman --password wsman -y basic | grep "<wsmid:ProductVendor>Openwsman Project</wsmid:ProductVendor>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -y"
    # test option: -a
    wsman invoke http://schema.omc-project.org/wbem/wscim/1/cim-schema/2/OMC_InitdService?SystemCreationClassName=OMC_UnitaryComputerSystem -h localhost --port 5985 -u wsman --password wsman -a ServiceStatus 2>&1 | grep "<wsa:Action>"
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -a"
    # test option: -C
    wsman identify -h localhost --port 5985 -u wsman --password wsman -C common/openwsman_client.conf
    CHECK_RESULT $? 0 0 "wamancli: faild to test option -C"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/openwsman/test_simple_auth.passwd
    kill -9 $(pgrep openwsmand)
    docker stop ss5
    docker rm -f ss5
    DNF_REMOVE
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
