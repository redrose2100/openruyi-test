#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023-4-20
# @License   :   Mulan PSL v2
# @Desc      :   Command zookeeper
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "apache-zookeeper"
    cp /opt/zookeeper/conf/zoo.cfg /opt/zookeeper/conf/zoo.cfg.bak
    local_ip=$(hostname -I |awk '{print $1}')
}

function run_test() {
    LOG_INFO "start to run test."
    sed -i 's/^dataDir=.*/dataDir=\/home\/zookeeper\/dataDir/g' /opt/zookeeper/conf/zoo.cfg
    mkdir -p /home/zookeeper/dataDir
    echo 1 >  /home/zookeeper/dataDir/myid
    cat /home/zookeeper/dataDir/myid 
    echo server.1="$local_ip":8881:7771 >>/opt/zookeeper/conf/zoo.cfg
    bash /opt/zookeeper/bin/zkServer.sh start
    CHECK_RESULT $? 0 0 "don't dispaly STARTED"
    chmod -R 777 /opt/zookeeper/logs/
    chmod -R 777 /home/zookeeper/dataDir/
    systemctl start zookeeper
    SLEEP_WAIT 15
    bash /opt/zookeeper/bin/zkServer.sh status | grep "Mode:"
    CHECK_RESULT $? 0 0 "don't dispaly ZooKeeper" 
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    bash /opt/zookeeper/bin/zkServer.sh stop
    DNF_REMOVE "$@"
    rm -rf /home/zookeeper/dataDir
    mv /opt/zookeeper/conf/zoo.cfg.bak /opt/zookeeper/conf/zoo.cfg
    LOG_INFO "End to restore the test environment."
}
main "$@"
