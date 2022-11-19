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
    LOG_INFO "Start testing swanctl value --counters"
    swanctl --counters|grep "ike-rekey-init"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --initiate"
    swanctl --initiate --child shared &
    CHECK_RESULT $?
    ps -ef|grep "child shared"|grep -v grep
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --terminate"
    swanctl --terminate --ike shared > strongswan_test_terminate.log
    CHECK_RESULT $?
    cat strongswan_test_terminate.log |grep "terminate completed successfully"
    CHECK_RESULT $?

    #terminate命令之后需要重新启动strongswan服务器
    strongswan restart
    CHECK_RESULT $?
    sleep 5
    LOG_INFO "Start testing swanctl value --rekey"
    swanctl --rekey --ike shared>strongswan_test_rekey.log
    CHECK_RESULT $?
    cat strongswan_test_rekey.log |grep "rekey completed successfully"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --redirect"
    swanctl --redirect --help|grep "swanctl --redirect"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --uninstall"
    swanctl --uninstall --help|grep "swanctl --uninstall"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --install"
    swanctl --install --help|grep "swanctl --install"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-sas"
    swanctl --list-sas>strongswan_test_list-sas.log
    CHECK_RESULT $?
    cat strongswan_test_list-sas.log |grep "active"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-sas"
    swanctl --monitor-sa &
    CHECK_RESULT $?
    ps -ef|grep "swanctl --monitor-sa"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "swanctl --monitor-sa"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-pols"
    swanctl --list-pols
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-authorities"
    swanctl --list-authorities
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-conns"
    swanctl --list-conns>strongswan_test_list-conns.log
    CHECK_RESULT $?
    cat strongswan_test_list-conns.log |grep "local pre-shared key authentication"
    CHECK_RESULT $?
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf strongswan_test*.log
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

