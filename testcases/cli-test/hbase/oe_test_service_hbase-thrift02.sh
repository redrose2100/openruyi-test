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
# @Author    :   yangxi
# @Contact   :   1820463064@qq.com
# @Date      :   2025/08/12
# @License   :   Mulan PSL v2
# @Desc      :   Test hbase-thrift.service restart
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hbase hadoop-3.1-hdfs hadoop-3.1-mapreduce hadoop-3.1-yarn"
    echo "export JAVA_HOME=/usr/lib/jvm/jre" >>/usr/libexec/hadoop-layout.sh
    sed -i "/Group=hadoop/a SuccessExitStatus=143" /usr/lib/systemd/system/hadoop-datanode.service
    sed -i "/Group=hadoop/a SuccessExitStatus=143" /usr/lib/systemd/system/hadoop-namenode.service
    systemctl daemon-reload
    expect <<EOF
        set timeout 600
        spawn sudo -u hdfs hdfs namenode -format
        expect {
            "(Y or N)" {
                send "Y\r"
            }
        }
        expect eof
EOF
    sed -i "/<configuration>/a <property>\n<name>hbase.unsafe.stream.capability.enforce<\/name>\n<value>false<\/value>\n<\/property>" /etc/hbase/hbase-site.xml
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl start hbase-master.service
    systemctl start hbase-regionserver.service
    systemctl start hadoop-namenode.service
    systemctl start hadoop-datanode.service
    systemctl start zookeeper.service
    systemctl start hbase-thrift.service 
    sudo -u hdfs hadoop fs -chmod 777 /
    LOG_INFO "Test 1: Check HBase Shell version"
    echo "version" | sudo -u hbase hbase shell -n 2>&1 | grep -i "HBase"
    CHECK_RESULT $? 0 0 "HBase shell startup check failed"
    LOG_INFO "Test 2: Verify basic HBase functionality"
    echo -e "create 'test_table', 'cf'\nlist\ndisable 'test_table'\ndrop 'test_table'" | sudo -u hbase hbase shell -n 2>&1 | grep -q "test_table"
    CHECK_RESULT $? 0 0 "HBase basic operations check failed"
    LOG_INFO "Test 3: Check HBase Thrift port listening"
    netstat -tlnp | grep 9090
    CHECK_RESULT $? 0 0 "HBase Thrift port is not listening"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop hadoop-namenode.service
    systemctl stop hadoop-datanode.service
    systemctl stop zookeeper.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
