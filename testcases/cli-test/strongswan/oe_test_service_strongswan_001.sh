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
    sleep 5

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

    LOG_INFO "Start testing strongswan value -h"
    strongswan --help|grep "strongswan command \[arguments\]"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value start"
    strongswan start
    CHECK_RESULT $?
    sleep 3
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $?
    
    LOG_INFO "Start testing strongswan value stop"
    strongswan stop
    CHECK_RESULT $?
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $? 1

    LOG_INFO "Start testing strongswan value restart"
    strongswan start
    CHECK_RESULT $?
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $?
    strongswan restart
    CHECK_RESULT $?
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value update"
    strongswan update >strongswan_test_update.log 2>&1 
    CHECK_RESULT $?
    cat strongswan_test_update.log |grep "Updating strongSwan IPsec configuration"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value reload"
    strongswan reload >strongswan_test_reload.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_reload.log |grep "Reloading strongSwan IPsec configuration"
    CHECK_RESULT $?

    connectionname=`strongswan statusall|grep "Connections" -A 1|tail -n 1|awk -F: {'print $1'}`
    LOG_INFO "Start testing strongswan value up"
    CHECK_RESULT $?
    strongswan up $connectionname & 
    CHECK_RESULT $?
    ps -ef|grep "strongswan up"|grep -v grep
    CHECK_RESULT $?

    sleep 3

    LOG_INFO "Start testing strongswan value down"
    CHECK_RESULT $?
    strongswan down shared>strongswan_test_down.log
    CHECK_RESULT $?
    cat strongswan_test_down.log |grep "closed successfully"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value route"
    CHECK_RESULT $?
    strongswan route $connectionname >strongswan_test_route.log
    CHECK_RESULT $?
    cat strongswan_test_route.log |grep "'shared' routed"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value unroute"
    CHECK_RESULT $?
    strongswan unroute $connectionname >strongswan_test_unroute.log
    CHECK_RESULT $?
    cat strongswan_test_unroute.log 
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

