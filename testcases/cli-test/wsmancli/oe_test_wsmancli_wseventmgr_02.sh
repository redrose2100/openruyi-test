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
    docker run -d -it --rm -p 0.0.0.0:5988:5988 -p 0.0.0.0:5989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    SLEEP_WAIT 20
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test command: wseventmgr
    # SYNOPSIS: wseventmgr [-X -Y -y -C -O -V -v -I --enum-context -i]
    # test option: -X -Y
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@127.0.0.1:5985/wsman -X socks5://127.0.0.1:1080 -d 6 -v -Y wsman:wsman 2>&1 | grep "SOCKS5 request granted."
        CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -X -Y"
    fi
    # test option: -y
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -y basic -d 6 2>&1 | grep "WWW-Authenticate: Basic"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -y"
    # test option: -C
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -C common/openwsman_client.conf
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -C"
    # test option: -O
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -O generate.txt
    test -f generate.txt
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -O"
    # test option: -V
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -d 6 -V 2>&1 | grep "cl->authentication.verify_peer: 0"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -V"
    # test option: -v
    wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -b http://wsman:wsman@localhost:5985/wsman -d 6 -v 2>&1 | grep verify
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -v"
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        # test option: -I after 3 sceconds get a fail message if not -I will wait more long time
        wseventmgr subscribe 'http://schemas.dmtf.org/wbem/wscim/1/*' -x "SELECT * FROM CIM_ProcessIndication" -D 'http://schemas.microsoft.com/wbem/wsman/1/WQL' -Z 'http://127.0.0.1:80/eventsink' -h www.baidu.com --port 5985 -u wsman --password wsman -I 3 -d 6 2>&1 | grep "Connection timed out"
        CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -I"
    fi
    # test option:  -C --enum-context  -C conflict with -C, --config-file=<file>  Alternate configuration file
    wseventmgr pull http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_Process -h localhost --port 5985 -u wsman --password wsman -R --enum-context 12345 2>&1 | grep "<wsen:EnumerationContext>12345</wsen:EnumerationContext>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --enum-context"
    # test option:  -i
    wseventmgr unsubscribe -i 123123 -u wsman -p wsman -R 2>&1 | grep "<wse:Identifier>123123</wse:Identifier>"
    CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -i"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep openwsmand)
    rm -rf generate.txt /etc/openwsman/test_simple_auth.passwd
    docker stop openpegasus ss5
    docker rm -f ss5
    mv -rf /etc/docker/daemon-old.json /etc/docker/daemon.json
    DNF_REMOVE "$@"
    # sleep 10 seconds ensure openwsmand be killed
    SLEEP_WAIT 10
    LOG_INFO "End to restore the test environment."
}

main "$@"
