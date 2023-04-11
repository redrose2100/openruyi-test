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
# @Desc      :   Test swanctl command 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "strongswan podman tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    podman stop -all
    podman rm -f $(podman ps -qa)
    podman load < ./test_file/vpn-server.tar
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
    swanctl --counters | grep "ike-rekey-init"
    CHECK_RESULT $? 0 0 "Failed to check the --counters"
    swanctl --initiate --child shared &
    pgrep -f "child shared"
    CHECK_RESULT $? 0 0 "Failed to check the --initiate"
    swanctl --terminate --ike shared > strongswan_test_terminate.log
    grep "terminate completed successfully" strongswan_test_terminate.log
    CHECK_RESULT $? 0 0 "Failed to check the --terminate"
    strongswan restart
    SLEEP_WAIT 5
    swanctl --rekey --ike shared>strongswan_test_rekey.log
    grep "rekey completed successfully" strongswan_test_rekey.log
    CHECK_RESULT $? 0 0 "Failed to check the --rekey"
    swanctl --redirect --help | grep "swanctl --redirect"
    CHECK_RESULT $? 0 0 "Failed to check the --redirect"
    swanctl --uninstall --help | grep "swanctl --uninstall"
    CHECK_RESULT $? 0 0 "Failed to check the --uninstall"
    swanctl --install --help | grep "swanctl --install"
    CHECK_RESULT $? 0 0 "Failed to check the install"
    swanctl --list-sas>strongswan_test_list-sas.log
    grep "active" strongswan_test_list-sas.log
    CHECK_RESULT $? 0 0 "Failed to check the --list-sas"
    swanctl --monitor-sa &
    pgrep -f "swanctl --monitor-sa"
    CHECK_RESULT $? 0 0 "Failed to check the --monitor-sa"
    kill -9 $(pgrep -f "swanctl --monitor-sa")
    swanctl --list-pols
    CHECK_RESULT $? 0 0 "Failed to check the --list-pols"
    swanctl --list-authorities
    CHECK_RESULT $? 0 0 "Failed to check the --list-authorities"
    swanctl --list-conns>strongswan_test_list-conns.log
    grep "local pre-shared key authentication" strongswan_test_list-conns.log
    CHECK_RESULT $? 0 0 "Failed to check the --list-conns"
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
