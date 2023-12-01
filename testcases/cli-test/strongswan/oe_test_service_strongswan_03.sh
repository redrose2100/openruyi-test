#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test strongswan command 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "strongswan podman tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    podman stop -all
    podman rm -f $(podman ps -qa)
    SLEEP_WAIT 5 "podman load < ./test_file/vpn-server.tar"
    podman run -itd --name vpn --env-file ./test_file/vpn.env -p 700:700/udp -p 4700:4700/udp -d --privileged docker.io/hwdsl2/ipsec-vpn-server:latest
    SLEEP_WAIT 5 "strongswan stop"
    SLEEP_WAIT 3
    grep "shared" /etc/strongswan/ipsec.conf || cat ./test_file/ipsec_add.conf >> /etc/strongswan/ipsec.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    strongswan start
    SLEEP_WAIT 3
    pgrep -f "starter"
    CHECK_RESULT $? 0 0 "Failed to check the start"
    strongswan listcrls
    CHECK_RESULT $? 0 0 "Failed to check the listcrls"
    strongswan listocsp
    CHECK_RESULT $? 0 0 "Failed to check the listocsp"
    strongswan listplugins
    CHECK_RESULT $? 0 0 "Failed to check the listplugins"
    strongswan listcounters> strongswan_test_listcounters.log
    grep "List of IKE counters:" strongswan_test_listcounters.log
    CHECK_RESULT $? 0 0 "Failed to check the listcounters"
    strongswan rereadocspcerts 
    CHECK_RESULT $? 0 0 "Failed to check the rereadocspcerts"
    strongswan rereadacerts
    CHECK_RESULT $? 0 0 "Failed to check the rereadacerts"
    strongswan rereadaacerts
    CHECK_RESULT $? 0 0 "Failed to check the rereadaacerts"
    strongswan resetcounters 
    CHECK_RESULT $? 0 0 "Failed to check the resetcounters"
    strongswan rereadsecrets
    CHECK_RESULT $? 0 0 "Failed to check the rereadsecrets"
    strongswan rereadcacerts 
    CHECK_RESULT $? 0 0 "Failed to check the rereadcacerts"
    strongswan rereadcrls
    CHECK_RESULT $? 0 0 "Failed to check the rereadcrls"
    strongswan rereadall
    CHECK_RESULT $? 0 0 "Failed to check the rereadall"
    strongswan purgecerts
    CHECK_RESULT $? 0 0 "Failed to check the purgecerts"
    strongswan purgecrls
    CHECK_RESULT $? 0 0 "Failed to check the purgecrls"
    strongswan purgeike
    CHECK_RESULT $? 0 0 "Failed to check the purgeike"
    strongswan purgeocsp
    CHECK_RESULT $? 0 0 "Failed to check the purgeocsp"
    strongswan scepclient --help>strongswan_test_scepclient.log 2>&1
    grep "Usage: scepclient" strongswan_test_scepclient.log
    CHECK_RESULT $? 0 0 "Failed to check the scepclient"
    strongswan pki>strongswan_test_pki.log
    grep "strongSwan 5.7.2 PKI tool" strongswan_test_pki.log
    CHECK_RESULT $? 0 0 "Failed to check the pki"
    strongswan stroke --help>strongswan_test_stroke.log
    grep "stroke \[OPTIONS\] command \[ARGUMENTS\]" strongswan_test_stroke.log
    CHECK_RESULT $? 0 0 "Failed to check the stroke"
    strongswan version | grep "Linux strongSwan"
    CHECK_RESULT $? 0 0 "Failed to check the version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf strongswan_test*.log test_file
    strongswan stop
    SLEEP_WAIT 3 "podman stop -all"
    podman rm -f $(podman ps -qa)
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
