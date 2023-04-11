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
# @Date      :   2023/2/21
# @License   :   Mulan PSL v2
# @Desc      :   Test strongswan command 
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "strongswan podman tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    podman stop -all
    podman rm -f $(podman ps -qa)
    SLEEP_WAIT 5 "podman load < ./test_file/vpn-server.tar"
    podman run -itd --name vpn --env-file ./test_file/vpn.env -p 700:700/udp -p 4700:4700/udp -d --privileged docker.io/hwdsl2/ipsec-vpn-server:latest
    pgrep -f "strongswan" && strongswan stop
    SLEEP_WAIT 3 "rm -rf strongswan_test*.log"
    log_time=$(date '+%Y-%m-%d %T')
    grep "shared" /etc/strongswan/ipsec.conf || cat ./test_file/ipsec_add.conf >> /etc/strongswan/ipsec.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    strongswan --help|grep "strongswan command \[arguments\]"
    CHECK_RESULT $? 0 0 "Failed to check the --help"
    strongswan start
    CHECK_RESULT $?
    SLEEP_WAIT 3
    pgrep -f "starter"
    CHECK_RESULT $? 0 0 "Failed to check the start"
    strongswan stop
    CHECK_RESULT $?
    pgrep -f "starter"
    CHECK_RESULT $? 1 0 "Failed to check the stop"
    strongswan start
    strongswan restart
    pgrep -f "starter"
    CHECK_RESULT $? 0 0 "Failed to check the restart"
    strongswan update >strongswan_test_update.log 2>&1 
    grep "Updating strongSwan IPsec configuration" strongswan_test_update.log
    CHECK_RESULT $? 0 0 "Failed to check the update"
    strongswan reload >strongswan_test_reload.log 2>&1
    grep "Reloading strongSwan IPsec configuration" strongswan_test_reload.log
    CHECK_RESULT $? 0 0 "Failed to check the reload"
    SLEEP_WAIT 3
    connectionname=`strongswan statusall|grep "Connections" -A 1|tail -n 1|awk -F: {'print $1'}`
    strongswan up $connectionname &
    pgrep -f "strongswan up"
    CHECK_RESULT $? 0 0 "Failed to check the up"
    SLEEP_WAIT 3
    strongswan down shared>strongswan_test_down.log
    grep "closed successfully" strongswan_test_down.log
    CHECK_RESULT $? 0 0 "Failed to check the down"
    strongswan route $connectionname >strongswan_test_route.log
    grep "'shared' routed" strongswan_test_route.log
    CHECK_RESULT $? 0 0 "Failed to check the route"
    strongswan unroute $connectionname >strongswan_test_unroute.log
    grep "trap policy 'shared' unrouted" strongswan_test_unroute.log
    CHECK_RESULT $? 0 0 "Failed to check the unroute"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf strongswan_test*.log test_file
    pgrep -f "starter" && strongswan stop
    SLEEP_WAIT 3 "podman stop -all"
    podman rm -f $(podman ps -qa)
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

