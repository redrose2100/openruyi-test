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

    #先启动strongswan服务，这个是完成后续测试的条件
    strongswan start
    sleep 3

    #开始测试各个参数
    LOG_INFO "Start testing charon-cmd value --ike-proposal"
    charon-cmd  --host 114.114.114.114 --identity shared --ike-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-ike-proposal.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "ike-proposal"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "ike-proposal"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --esp-proposal"
    charon-cmd  --host 114.114.114.114 --identity shared --esp-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-esp-proposal.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "esp-proposal"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "esp-proposal"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --ah-proposal"
    charon-cmd  --host 114.114.114.114 --identity shared --ah-proposal aes128-sha1-modp768  >strongswan_test_charon-cmd-ike-proposal.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "ah-proposal"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "ah-proposal"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --local-ts"
    charon-cmd  --host 114.114.114.114 --identity shared --local-ts 127.0.0.1 >strongswan_test_charon-cmd-local-ts.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "local-ts"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "local-ts"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --remote-ts"
    charon-cmd  --host 114.114.114.114 --identity shared --remote-ts 127.0.0.1 >strongswan_test_charon-cmd-remote-ts.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "remote-ts"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "remote-ts"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --profile"
    charon-cmd  --host 114.114.114.114 --identity shared --profile IKEv2-EAP>strongswan_test_charon-cmd-profile.log 2>&1  &
    CHECK_RESULT $?
    ps -ef|grep "IKEv2-EAP"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "IKEv2-EAP"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    expect <<-END >tmp.txt
    spawn fluent-gem signin
    expect "Password:"
    send "whatever\n"
    expect eof
END
    CHECK_RESULT $? 0 0 "Check fluent-gem signin failed"
    LOG_INFO "Start testing charon-cmd value --p12"
    charon-cmd  --host 114.114.114.114 --identity shared --p12 ./test_file/test_strongswan.p12 &
    CHECK_RESULT $?
    ps -ef|grep "\/test_file\/test_strongswan.p12"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "\/test_file\/test_strongswan.p12"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --agent"
    ssh-agent >strongswan_test_charon-cmd-ssh-agent.log
    agent_file=`cat strongswan_test_charon-cmd-ssh-agent.log |grep "SSH_AUTH_SOCK="|awk -F"=" {'print $2'}|awk -F";" {'print $1'}`
    echo $agent_file
    charon-cmd  --host 114.114.114.114 --identity shared --agent=$agent_file>strongswan_test_charon-cmd-agent.log
    cat strongswan_test_charon-cmd-agent.log |grep "Starting charon-cmd IKE client"
    CHECK_RESULT $?

    LOG_INFO "Start testing charon-cmd value --rsa"
    charon-cmd  --host 114.114.114.114 --identity shared --rsa ./test_file/test_strongswan.rsa
    CHECK_RESULT $?
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf strongswan_test*.log tmp.txt
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

