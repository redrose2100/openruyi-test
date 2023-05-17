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
    strongswan down-srcip end
    CHECK_RESULT $? 0 0 "Failed to check the down-srcip end"
    strongswan down-srcip start 
    CHECK_RESULT $? 0 0 "Failed to check the down-srcip start"
    strongswan status>strongswan_test_status.log
    grep "Security Associations" strongswan_test_status.log
    CHECK_RESULT $? 0 0 "Failed to check status"
    strongswan statusall >strongswan_test_statusall.log
    grep "Status of IKE charon daemon" strongswan_test_statusall.log
    CHECK_RESULT $? 0 0 "Failed to check the statusall"
    strongswan listalgs>strongswan_test_listalgs.log
    grep "List of registered IKE algorithms:" strongswan_test_listalgs.log
    CHECK_RESULT $?  0 0 "Failed to check the listalgs"
    strongswan listpubkeys
    CHECK_RESULT $? 0 0 "Failed to check the listpubkeys"
    strongswan listcacerts
    CHECK_RESULT $? 0 0 "Failed to check the listcacerts"
    strongswan listocspcerts
    CHECK_RESULT $? 0 0 "Failed to check the listocspcerts"
    strongswan listacerts
    CHECK_RESULT $? 0 0 "Failed to check the listacerts"
    strongswan listgroups>strongswan_test_listgroups.log
    grep "stroke \[OPTIONS\] command" strongswan_test_listgroups.log
    CHECK_RESULT $? 0 0 "Failed to check the listgroups"
    connectionname=`strongswan statusall|grep "Connections" -A 1|tail -n 1|awk -F: {'print $1'}`
    strongswan listcainfos $connectionname 
    CHECK_RESULT $? 0 0 "Failed to check the listcainfos"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf strongswan_test*.log test_file
    pgrep -f "starter" && strongswan stop
    SLEEP_WAIT 3 "podman stop -all"
    podman rm -f $(podman ps -qa)
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
