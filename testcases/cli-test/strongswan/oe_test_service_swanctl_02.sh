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
    swanctl --list-certs  
    CHECK_RESULT $? 0 0 "Failed to check the --list-certs"
    swanctl --list-pools
    CHECK_RESULT $? 0 0 "Failed to check the --list-pools"
    swanctl --list-algs>strongswan_test_list-algs.log
    grep "encryption:" strongswan_test_list-algs.log
    CHECK_RESULT $? 0 0 "Failed to check the --list-algs"
    swanctl --list-certs  
    CHECK_RESULT $? 0 0 "Failed to check the --list-certs"
    swanctl --list-pools
    CHECK_RESULT $? 0 0 "Failed to check the --list-pools"
    swanctl --list-algs>strongswan_test_list-algs.log
    grep "encryption:" strongswan_test_list-algs.log
    CHECK_RESULT $? 0 0 "Failed to check the --list-algs"
    swanctl --flush-certs
    CHECK_RESULT $? 0 0 "Failed to check the --flush-certs"
    swanctl --load-all>strongswan_test_load-all.log 2>&1
    grep "authorities" strongswan_test_load-all.log
    CHECK_RESULT $? 0 0 "Failed to check the --load-all"
    swanctl --load-authorities>strongswan_test_load-authorities.log 2>&1
    grep "authorities" strongswan_test_load-authorities.log
    CHECK_RESULT $? 0 0 "Failed to check the --load-authorities"
    swanctl --load-conns>strongswan_test_load-conns.log 2>&1
    grep "connections" strongswan_test_load-conns.log
    CHECK_RESULT $? 0 0 "Failed to check the --load-conns"
    swanctl --load-pools>strongswan_test_load-pools.log 2>&1
    grep "files found matching" strongswan_test_load-pools.log
    CHECK_RESULT $? 0 0 "Failed to check the --load-pools"
    swanctl --load-creds>strongswan_test_load-creds.log 2>&1
    grep "files found matching" strongswan_test_load-creds.log
    CHECK_RESULT $? 0 0 "Failed to check the --load-creds"
    swanctl --log &
    pgrep -f "swanctl --log"
    CHECK_RESULT $? 0 0 "Failed to check the --log"
    kill -9 $(pgrep -f "swanctl --log")
    SLEEP_WAIT 5
    swanctl --version | grep "strongSwan swanctl"
    CHECK_RESULT $? 0 0 "Failed to check the --version"
    swanctl --stats>strongswan_test_load-stats.log
    grep "uptime" strongswan_test_load-stats.log
    CHECK_RESULT $? 0 0 "Failed to check the --stats"
    swanctl --reload-settings
    pgrep -f "strongswan"
    CHECK_RESULT $? 0 0 "Failed to check the --reload-settings"
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
