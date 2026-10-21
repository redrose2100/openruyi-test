#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2025/08/12
# @License   :   Mulan PSL v2
# @Desc      :   Test hbase-master.service restart
# #############################################

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hbase hadoop-3.1-hdfs hadoop-3.1-mapreduce hadoop-3.1-yarn"
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        sudo alternatives --set java "$(find /usr/lib/jvm/java-11-openjdk-11.*/bin/java | head -n1)"
    fi
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
    systemctl start hadoop-namenode.service
    systemctl start hadoop-datanode.service
    systemctl start zookeeper.service
    sudo -u hdfs hadoop fs -chmod 777 /
    sed -i "/<configuration>/a <property>\n<name>hbase.unsafe.stream.capability.enforce<\/name>\n<value>false<\/value>\n<\/property>" /etc/hbase/hbase-site.xml
    systemctl start hbase-regionserver.service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Test 1: Check if HBase shell can start"
    echo "status" | hbase shell 2>&1 | grep -q "version"
    CHECK_RESULT $? 0 0 "HBase shell startup test failed"
    LOG_INFO "Test 2: Check if can create table"
    echo -e "create 'test_table', 'cf'\nlist" | hbase shell 2>&1 | grep -q "test_table"
    CHECK_RESULT $? 0 0 "HBase table creation test failed"
    LOG_INFO "Test 3: Check if can insert and query data"
    echo -e "put 'test_table', 'row1', 'cf:col1', 'value1'\nget 'test_table', 'row1'" | hbase shell 2>&1 | grep -q "value1"
    CHECK_RESULT $? 0 0 "HBase data insertion and query test failed"
    echo -e "disable 'test_table'\ndrop 'test_table'" | hbase shell >/dev/null 2>&1
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop hadoop-namenode.service
    systemctl stop hadoop-datanode.service
    systemctl stop zookeeper.service
    systemctl stop hbase-regionserver.service
    systemctl stop hbase-master.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
