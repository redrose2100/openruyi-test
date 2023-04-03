#!/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.4.3
# @License   :   Mulan PSL v2
# @Desc      :   atune create environment and environment restore public method
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

ARRAY_PROFILE=("arm-native-android-container-robox" "basic-test-suite-baseline-fio" "basic-test-suite-baseline-lmbench" "basic-test-suite-baseline-netperf" "basic-test-suite-baseline-stream" "basic-test-suite-baseline-unixbench" "basic-test-suite-speccpu-speccpu2006" "basic-test-suite-specjbb-specjbb2015" "big-data-hadoop-hdfs-dfsio-hdd" "big-data-hadoop-hdfs-dfsio-ssd" "big-data-hadoop-spark-bayesian" "big-data-hadoop-spark-kmeans" "big-data-hadoop-spark-sql1" "big-data-hadoop-spark-sql10" "big-data-hadoop-spark-sql2" "big-data-hadoop-spark-sql3" "big-data-hadoop-spark-sql4" "big-data-hadoop-spark-sql5" "big-data-hadoop-spark-sql6" "big-data-hadoop-spark-sql7" "big-data-hadoop-spark-sql8" "big-data-hadoop-spark-sql9" "big-data-hadoop-spark-tersort" "big-data-hadoop-spark-wordcount" "cloud-compute-kvm-host" "database-mariadb-2p-tpcc-c3" "database-mariadb-4p-tpcc-c3" "database-mongodb-2p-sysbench" "database-mysql-2p-sysbench-hdd" "database-mysql-2p-sysbench-ssd" "database-postgresql-2p-sysbench-hdd" "database-postgresql-2p-sysbench-ssd" "default-default" "docker-mariadb-2p-tpcc-c3" "docker-mariadb-4p-tpcc-c3" "hpc-gatk4-human-genome" "in-memory-database-redis-redis-benchmark" "middleware-dubbo-dubbo-benchmark" "storage-ceph-vdbench-hdd" "storage-ceph-vdbench-ssd" "virtualization-consumer-cloud-olc" "virtualization-mariadb-2p-tpcc-c3" "virtualization-mariadb-4p-tpcc-c3" "web-apache-traffic-server-spirent-pingpo" "web-nginx-http-long-connection" "web-nginx-https-short-connection")
ARRAY_SERVICE=("arm-native" "basic-test-suite" "big-data" "cloud-compute" "database" "default" "docker" "hpc" "in-memory-database" "middleware" "storage" "virtualization" "web")
function deploy_autund()
{
    DNF_INSTALL "atune  atune-engine"
    disk_name=$(lsblk | grep disk | awk 'NR==1{print $1}')
    cp /etc/atuned/atuned.cnf /etc/atuned/atuned.cnf.bak
    cp /etc/atuned/engine.cnf /etc/atuned/engine.cnf.bak
    sed -i "s/^disk =.*/disk = ${disk_name}/g" /etc/atuned/atuned.cnf
    sed -i "s/^network =.*/network = ${NODE1_NIC}/g" /etc/atuned/atuned.cnf
    sed -i "s/rest_tls = true/rest_tls = false/g" /etc/atuned/atuned.cnf
    sed -i "s/engine_tls = true/engine_tls = false/g" /etc/atuned/atuned.cnf
    sed -i "s/engine_tls = true/engine_tls = false/g" /etc/atuned/engine.cnf
    systemctl start atuned
    systemctl status atuned |grep running
    CHECK_RESULT $? 0 0 "atuned service startup failure"
    systemctl start atune-engine
    systemctl status atune-engine |grep running
    CHECK_RESULT $? 0 0 "atune-engine service startup failure"
}

function clean_autund() {
    systemctl stop atuned
    systemctl stop atune-engine
    rm -fr /etc/atuned/atuned.cnf /etc/atuned/atuned.cnf
    mv /etc/atuned/atuned.cnf.bak /etc/atuned/atuned.cnf
    mv /etc/atuned/engine.cnf.bak /etc/atuned/engine.cnf
    DNF_REMOVE
}
