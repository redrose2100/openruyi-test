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
    LOG_INFO "Start testing strongswan value down-srcip"
    strongswan start
    CHECK_RESULT $?
    sleep 3
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $?
    strongswan down-srcip end
    CHECK_RESULT $?
    strongswan down-srcip start 
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value status"
    strongswan status>strongswan_test_status.log
    CHECK_RESULT $?
    cat strongswan_test_status.log |grep "Security Associations"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value statusall"
    strongswan statusall >strongswan_test_statusall.log
    CHECK_RESULT $?
    cat strongswan_test_statusall.log |grep "Status of IKE charon daemon"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listalgs"
    strongswan listalgs>strongswan_test_listalgs.log
    CHECK_RESULT $?
    cat strongswan_test_listalgs.log |grep "List of registered IKE algorithms:"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listpubkeys"
    strongswan listpubkeys
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listcacerts"
    strongswan listcacerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listocspcerts"
    strongswan listocspcerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listacerts"
    strongswan listacerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listgroups"
    strongswan listgroups>strongswan_test_listgroups.log
    CHECK_RESULT $?
    cat strongswan_test_listgroups.log |grep "stroke \[OPTIONS\] command"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listcainfos"
    connectionname=`strongswan statusall|grep "Connections" -A 1|tail -n 1|awk -F: {'print $1'}`
    CHECK_RESULT $?
    strongswan listcainfos $connectionname 
    CHECK_RESULT $?

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf strongswan_test*.log
    exist_strongswan=`ps -ef|grep strongswan|grep -v grep|grep starter`
    echo $exist_strongswan
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

