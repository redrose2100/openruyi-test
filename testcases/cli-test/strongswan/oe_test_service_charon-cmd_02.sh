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
    charon-cmd  --host 114.114.114.114 --identity shared --ike-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-ike-proposal.log 2>&1  &
    pgrep -f "ike-proposal"
    CHECK_RESULT $? 0 0 "Failed to check the --ike-proposal"
    kill -9 $(pgrep -f "ike-proposal")
    charon-cmd  --host 114.114.114.114 --identity shared --esp-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-esp-proposal.log 2>&1  &
    pgrep -f "esp-proposal"
    CHECK_RESULT $? 0 0 "Start testing charon-cmd value --esp-proposal"
    kill -9 $(pgrep -f "esp-proposal")
    charon-cmd  --host 114.114.114.114 --identity shared --ah-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-ike-proposal.log 2>&1  &
    pgrep -f "ah-proposal"
    CHECK_RESULT $? 0 0 "Failed to check the --ah-proposal"
    kill -9 $(pgrep -f "ah-proposal")
    charon-cmd  --host 114.114.114.114 --identity shared --local-ts 127.0.0.1 >strongswan_test_charon-cmd-local-ts.log 2>&1  &
    pgrep -f "local-ts"
    CHECK_RESULT $? 0 0 "Failed to check the --local-ts"
    kill -9 $(pgrep -f "local-ts")
    charon-cmd  --host 114.114.114.114 --identity shared --remote-ts 127.0.0.1 >strongswan_test_charon-cmd-remote-ts.log 2>&1  &
    pgrep -f "remote-ts"
    CHECK_RESULT $? 0 0 "Failed to check the --remote-ts"
    kill -9 $(pgrep -f "remote-ts")
    charon-cmd  --host 114.114.114.114 --identity shared --profile IKEv2-EAP>strongswan_test_charon-cmd-profile.log 2>&1  &
    pgrep -f "IKEv2-EAP"
    CHECK_RESULT $? 0 0 "Failed to check the --profile"
    kill -9 $(pgrep -f "IKEv2-EAP")
    charon-cmd  --host 114.114.114.114 --identity shared --p12 ./test_file/test_strongswan.p12 &
    pgrep -f "\/test_file\/test_strongswan.p12"
    CHECK_RESULT $? 0 0 "Failed to check the --p12"
    kill -9 $(pgrep -f "test_file\/test_strongswan.p12")
    ssh-agent >strongswan_test_charon-cmd-ssh-agent.log
    agent_file=`cat strongswan_test_charon-cmd-ssh-agent.log |grep "SSH_AUTH_SOCK="|awk -F"=" {'print $2'}|awk -F";" {'print $1'}`
    charon-cmd  --host 114.114.114.114 --identity shared --agent=$agent_file>strongswan_test_charon-cmd-agent.log
    grep "Starting charon-cmd IKE client" strongswan_test_charon-cmd-agent.log
    CHECK_RESULT $? 0 0 "Failed to check the --agent"
    charon-cmd  --host 114.114.114.114 --identity shared --rsa ./test_file/test_strongswan.key.pem &
    CHECK_RESULT $? 0 0 "Failed to check the --rsa"
    pgrep -f "charon-cmd --host"
    CHECK_RESULT $? 0 0 "Failed to check the --rsa process"
    kill -9 $(pgrep -f "charon-cmd --host")
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf strongswan_test*.log tmp.txt test_file
    pgrep -f "strongswan" && strongswan stop
    SLEEP_WAIT 3 "podman stop -all"
    podman rm -f $(podman ps -qa)
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
