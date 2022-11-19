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

    strongswan start
    sleep 3

    #开始测试各个参数
    LOG_INFO "Start testing swanctl value --list-certs "
    swanctl --list-certs  
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-pools "
    swanctl --list-pools
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-algs "
    swanctl --list-algs>strongswan_test_list-algs.log
    CHECK_RESULT $?
    cat strongswan_test_list-algs.log |grep "encryption:"

    LOG_INFO "Start testing swanctl value --list-certs "
    swanctl --list-certs  
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-pools "
    swanctl --list-pools
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --list-algs "
    swanctl --list-algs>strongswan_test_list-algs.log
    CHECK_RESULT $?
    cat strongswan_test_list-algs.log |grep "encryption:"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --flush-certs"
    swanctl --flush-certs
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --load-all"
    swanctl --load-all>strongswan_test_load-all.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_load-all.log |grep "authorities"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --load-authorities"
    swanctl --load-authorities>strongswan_test_load-authorities.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_load-authorities.log |grep "authorities"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --load-conns"
    swanctl --load-conns>strongswan_test_load-conns.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_load-conns.log |grep "connections"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --load-pools"
    swanctl --load-pools>strongswan_test_load-pools.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_load-pools.log |grep "files found matching"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --load-creds"
    swanctl --load-creds>strongswan_test_load-creds.log 2>&1
    CHECK_RESULT $?
    cat strongswan_test_load-creds.log |grep "files found matching"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --log"
    swanctl --log &
    CHECK_RESULT $?
    ps -ef|grep "swanctl --log"|grep -v grep
    CHECK_RESULT $?
    ps -ef|grep "swanctl --log"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?
    sleep 5

    LOG_INFO "Start testing swanctl value --version"
    swanctl --version|grep "strongSwan swanctl"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --stats"
    swanctl --stats>strongswan_test_load-stats.log
    CHECK_RESULT $?
    cat strongswan_test_load-stats.log |grep "uptime"
    CHECK_RESULT $?

    LOG_INFO "Start testing swanctl value --stats"
    swanctl --reload-settings
    ps -ef|grep strongswan|grep -v grep
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

