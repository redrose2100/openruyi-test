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

    strongswan start
    CHECK_RESULT $?
    sleep 3
    ps -ef|grep strongswan|grep -v grep|grep starter
    CHECK_RESULT $?
    LOG_INFO "Start testing strongswan value listcrls"
    strongswan listcrls
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listocsp"
    strongswan listocsp
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listplugins"
    strongswan listplugins
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value listcounters"
    strongswan listcounters> strongswan_test_listcounters.log
    CHECK_RESULT $?
    cat strongswan_test_listcounters.log |grep "List of IKE counters:"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadocspcerts"
    strongswan rereadocspcerts 
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadacerts"
    strongswan rereadacerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadaacerts"
    strongswan rereadaacerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value resetcounters"
    strongswan resetcounters 
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadsecrets"
    strongswan rereadsecrets
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadcacerts"
    strongswan rereadcacerts 
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadcrls"
    strongswan rereadcrls
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value rereadall"
    strongswan rereadall
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value purgecerts"
    strongswan purgecerts
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value purgecrls"
    strongswan purgecrls
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value purgeike"
    strongswan purgeike
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value purgeocsp"
    strongswan purgeocsp
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value scepclient"
    strongswan scepclient --help>strongswan_test_scepclient.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_scepclient.log |grep "Usage: scepclient"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value pki"
    strongswan pki>strongswan_test_pki.log
    CHECK_RESULT $?
    cat strongswan_test_pki.log|grep "strongSwan 5.7.2 PKI tool"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value stroke"
    strongswan stroke --help>strongswan_test_stroke.log
    CHECK_RESULT $?
    cat strongswan_test_stroke.log|grep "stroke \[OPTIONS\] command \[ARGUMENTS\]"
    CHECK_RESULT $?

    LOG_INFO "Start testing strongswan value version"
    strongswan version|grep "Linux strongSwan"
    CHECK_RESULT $?
}

function post_test() {
    LOG_INFO "start environment cleanup."
    ps -ef|grep strongswan|grep -v grep|grep starter
    if [ $? -eq 0 ]
    then
        strongswan stop
        sleep 3
    fi
    #删除所有容器
    podman stop -all
    podman rm -f $(docker ps -qa)
    rm -rf strongswan_test*.log
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

