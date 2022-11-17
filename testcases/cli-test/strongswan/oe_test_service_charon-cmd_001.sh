#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test strongswan.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL strongswan
    DNF_INSTALL podman

    #删除所有容器
    podman stop -all
    podman rm -f $(docker ps -qa)

#通过容器环境启动strongswan的server端,，准备环境
    podman load < ./test_file/vpn-server.tar    
    podman run -itd --name vpn --env-file ./test_file/vpn.env -p 700:700/udp -p 4700:4700/udp -d --privileged docker.io/hwdsl2/ipsec-vpn-server:latest
    sleep 5

#关闭strongswan服务
    ps -ef|grep strongswan|grep -v grep|grep starter
    if [ $? -eq 0 ]
    then
        strongswan stop
        sleep 3
    fi
    rm -rf strongswan_test*.log
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"

#改写配置文件
    cat /etc/strongswan/ipsec.conf |grep "shared"
    if [ $? -ne 0 ]
    then
        cat ./test_file/ipsec_add.conf >> /etc/strongswan/ipsec.conf
    fi
}

function run_test() {
    LOG_INFO "Start testing..."

    #先启动strongswan服务，这个是完成后续测试的条件
    strongswan start
    sleep 3

    #开始测试各个参数
    LOG_INFO "Start testing charon-cmd value --help"
    charon-cmd --help|grep "Usage: charon-cmd"
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --version"
    charon-cmd --version|grep "charon-cmd, strongSwan"
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --host and --identity"
    charon-cmd  --host 114.114.114.114 --identity shared >strongswan_test_charon-cmd-host-identity.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "charon-cmd --host"|grep -v grep
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --eap-identity"
    charon-cmd  --host 114.114.114.114 --identity shared  --eap-identity shared >strongswan_test_charon-cmd-host-eapidentity.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "charon-cmd --host 114.114.114.114 --identity shared --eap-identity"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "charon-cmd --host 114.114.114.114 --identity shared --eap-identity"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --xauth-username"
    charon-cmd  --host 114.114.114.114 --identity shared  --xauth-username test_sun >strongswan_test_charon-cmd-host-eapidentity.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "\-\-xauth-username test_sun"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "\-\-xauth-username test_sun"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --remote-identity"
    charon-cmd  --host 114.114.114.114 --identity shared --remote-identity shared >strongswan_test_charon-cmd-remote-identity.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "\-\-remote-identity"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "\-\-remote-identity"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --cert"
    charon-cmd  --host 114.114.114.114 --identity shared --cert ./test_file/test_strongswan.pem  >strongswan_test_charon-cmd-cert.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "test_file\/test_strongswan.pem"|grep -v grep
    CHECK_RESULT $?
     ps -ef|grep "test_file\/test_strongswan.pem"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?


}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf strongswan_test*.log
    ps -ef|grep strongswan|grep -v grep|grep starter
    if [ $? -eq 0 ]
    then
        strongswan stop
        sleep 3
    fi
    #删除所有容器
    podman stop -all
    podman rm -f $(docker ps -qa)
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

