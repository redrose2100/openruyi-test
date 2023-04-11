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
# @Desc      :   Test charon-cmd command 
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
    SLEEP_WAIT 3 "rm -rf strongswan_test*.log"
    log_time=$(date '+%Y-%m-%d %T')
    grep "shared" /etc/strongswan/ipsec.conf || cat ./test_file/ipsec_add.conf >> /etc/strongswan/ipsec.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    strongswan start
    SLEEP_WAIT 3
    charon-cmd --help | grep "Usage: charon-cmd"
    CHECK_RESULT $? 0 0 "Failed to check the --help"
    charon-cmd --version|grep "charon-cmd, strongSwan"
    CHECK_RESULT $? 0 0 "Failed to check the --version"
    charon-cmd  --host 114.114.114.114 --identity shared >strongswan_test_charon-cmd-host-identity.log 2>&1  &
    pgrep -f "charon-cmd --host"
    CHECK_RESULT $? 0 0 "Failed to check the --host and --identity"
    charon-cmd  --host 114.114.114.114 --identity shared  --eap-identity shared >strongswan_test_charon-cmd-host-eapidentity.log 2>&1  &
    pgrep -f "charon-cmd --host 114.114.114.114 --identity shared --eap-identity"
    CHECK_RESULT $? 0 0 "Failed to check the --eap-identity"
    kill -9 $(pgrep -f "charon-cmd --host 114.114.114.114 --identity shared --eap-identity")
    charon-cmd  --host 114.114.114.114 --identity shared  --xauth-username test_sun >strongswan_test_charon-cmd-host-eapidentity.log 2>&1  &
    pgrep -f "\-\-xauth-username test_sun"
    CHECK_RESULT $? $? 0 0 "Failed to check the --xauth-username"
    kill -9 $(pgrep -f "xauth-username test_sun")
    charon-cmd  --host 114.114.114.114 --identity shared --remote-identity shared >strongswan_test_charon-cmd-remote-identity.log 2>&1  &
    pgrep -f "\-\-remote-identity"
    CHECK_RESULT $? 0 0 "Failed to check the --xauth-username"
    kill -9 $(pgrep -f "remote-identity")
    charon-cmd  --host 114.114.114.114 --identity shared --cert ./test_file/test_strongswan.pem  >strongswan_test_charon-cmd-cert.log 2>&1  &
    pgrep -f "test_file\/test_strongswan.pem"
    CHECK_RESULT $? 0 0 "Failed to check the --cert"
    kill -9 $(pgrep -f "test_file\/test_strongswan.pem")
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pgrep -f "strongswan" && strongswan stop
    SLEEP_WAIT 3 "podman stop -all"
    podman rm -f $(podman ps -qa)
    DNF_REMOVE
    rm -rf strongswan_test*.log test_file
    LOG_INFO "End to restore the test environment."
}

main "$@"
