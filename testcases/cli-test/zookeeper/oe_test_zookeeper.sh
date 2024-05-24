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
    local_ip=$(hostname -I |awk '{print $1}')
    data_dir="/home/zookeeper/dataDir"

    sed -i "s|^dataDir=.*|dataDir=$data_dir|g" /opt/zookeeper/conf/zoo.cfg
    echo server.1="$local_ip":8881:7771 >>/opt/zookeeper/conf/zoo.cfg

    mkdir -p $data_dir
    echo 1 > ${data_dir}/myid
}

function run_test() {
    LOG_INFO "start to run test."
    bash /opt/zookeeper/bin/zkServer.sh start
    CHECK_RESULT $? 0 0 "start failed." 1
    bash /opt/zookeeper/bin/zkServer.sh status
    CHECK_RESULT $? 0 0 "get status failed." 1
    bash /opt/zookeeper/bin/zkServer.sh stop
    CHECK_RESULT $? 0 0 "stop failed." 1

    chown zookeeper:zookeeper -R /opt/zookeeper/
    chown zookeeper:zookeeper -R /home/zookeeper/
    systemctl start zookeeper
    CHEK_RESULT $? 0 0 "start failed." 1
    systemctl status zookeeper
    CHECK_RESULT $? 0 0 "get status failed." 1
    systemctl stop zookeeper
    CHECK_RESULT $? 0 0 "stop failed." 1
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /home/zookeeper/
    rm -rf /opt/zookeeper/
    userdel zookeeper
    LOG_INFO "End to restore the test environment."
}
main "$@"
