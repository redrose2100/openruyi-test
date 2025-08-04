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
# @Author    :   yuanlulu
# @Contact   :   127248816@qq.com
# @Date      :   2023/07/03
# @License   :   Mulan PSL v2
# @Desc      :   gala-gopher common function
# #############################################
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162

source "${OET_PATH}"/libs/locallibs/common_lib.sh
GOPHER_CONF_PATH="/etc/gala-gopher/gala-gopher.conf"

function start_gopher() {
    rpm -qa | grep gala-gopher || yum install -y gala-gopher
    systemctl start gala-gopher
}

function clean_gopher() {
    systemctl stop gala-gopher
    yum remove -y gala-gopher
}

function get_unused_port() {
    local port

    for ((i = 0; i < 10; i++)); do
        port=$RANDOM
        lsof -i:"$port" || break
    done
    echo "$port"
}

function deploy_iperf() {
    which iperf3 || yum install -y iperf
    pkill -9 iperf3
    SSH_CMD "which iperf3 || yum install -y iperf3" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "pkill -9 iperf3" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function clean_iperf() {
    pkill -9 iperf3
    SSH_CMD "pkill -9 iperf3" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    which iperf3 || yum remove -y iperf3
    SSH_CMD "which iperf3 || yum remove -y iperf3" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function is_support_rest() {
    main_process=$(systemctl status gala-gopher | grep 'Main PID' | awk '{print $3}')
    ps -T -p "$main_process" | grep PROBEMNG
    echo $?
}

function check_log() {
    ls fail_log && {
        cat fail_log | wc -l | grep 0
        CHECK_RESULT $? 0 0
        cat fail_log #debug
    }
}

function start_redis() {
    #服务端
    yum install -y redis
    sed -i "s/bind 127.0.0.1/bind $ETS_LOCAL_IP/" /etc/redis.conf
    sed -i 's/protected-mode yes/protected-mode no/' /etc/redis.conf
    sed -i 's/daemonize no/daemonize yes/' /etc/redis.conf
    redis-server /etc/redis.conf
    #客户端
    SSH_CMD "yum install -y redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "pip3 config set global.index-url http://mirrors.tools.huawei.com/pypi/simple/" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "pip3 config set global.trusted-host mirrors.tools.huawei.com" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "pip3 install redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function clean_redis() {
    ps aux | grep redis | grep -v grep | grep -v test | awk '{print $2}' | xargs kill -9
    yum remove -y redis
    SSH_CMD "yum remove -y redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "pip3 uninstall redis -y" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function start_kafka() {
    #配置docker镜像 安装kafka
    yum install -y docker

    ls /etc/docker/daemon.json || {
        touch /etc/docker/daemon.json
        cat > /etc/docker/daemon.json << 'EOF'
{
"registry-mirrors":["https://rnd-dockerhub.huawei.com"],
"insecure-registries":["rnd-dockerhub.huawei.com","hub.witcloud.huawei.com"]
}
EOF
    }
    systemctl daemon-reload
    systemctl restart docker
    #下载kafka
    docker pull wurstmeister/zookeeper
    docker pull wurstmeister/kafka
    docker inspect wurstmeister/kafka | grep Architecture

    #启动kafka
    systemctl stop firewalld
    systemctl stop docker
    iptables-save > /etc/sysconfig/iptables
    systemctl start docker
    docker run -d --name zookeeper -p 2181:2181 -t wurstmeister/zookeeper
    docker run -d --name kafka -p 9092:9092 -e KAFKA_BROKER_ID=0 -e KAFKA_ZOOKEEPER_CONNECT="$ETS_LOCAL_IP":2181 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://"$ETS_LOCAL_IP":9092 -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 wurstmeister/kafka
    netstat -nutpl | grep 9092
}

function clean_kafka() {
    zookeeper_cid=$(docker ps | grep zookeeper | awk '{print $1}')
    kafka_cid=$(docker ps | grep kafka | awk '{print $1}')
    for docker_id in "$zookeeper_cid" "$kafka_cid"; do
        docker stop "$docker_id"
        docker rm "$docker_id"
    done
    systemctl stop docker
}

function start_gauss_server() {
    yum install -y docker
    cat > /etc/docker/daemon.json << 'EOF'
{
"insecure-registries":["hub.oepkgs.net"]
}
EOF
    systemctl daemon-reload
    systemctl restart docker
    docker pull hub.oepkgs.net/a-ops/opengauss:3.0.0
    docker images
    chmod 755 ./common/create_master_slave.shN
    ./common/create_master_slave.shN
    docker ps | grep opengauss
    #创建数据库
    chmod 755 ./common/docker_exec.sh
    chmod 755 ./common/gus.sql
    docker_id=$(docker ps | grep opengauss_master | awk '{print $1}')
    docker cp ./common/docker_exec.sh "$docker_id":/
    docker cp ./common/gus.sql "$docker_id":/
    docker exec -u omm -it "$docker_id" bash -ic /docker_exec.sh
}

function clean_gauss_server() {
    #删除数据库
    chmod 755 ./docker_drop.sh
    chmod 755 ./drop.sql
    docker cp ./docker_drop.sh "$docker_id":/
    docker cp ./drop.sql "$docker_id":/
    docker exec -u omm -it "$docker_id" bash -ic /docker_drop.sh
    docker_ids=$(docker ps | grep gauss | awk '{print $1}')
    for docker_id in $docker_ids; do
        docker stop "$docker_id"
        docker rm "$docker_id"
    done
    systemctl stop docker
}

function start_gauss_client() {
    SSH_CMD "rpm -q java || yum install -y java" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "wget https://sourceforge.net/projects/benchmarksql/files/benchmarksql-5.0.zip" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "unzip benchmarksql-5.0.zip" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "sed -i 's/9.82.*5432/${NODE1_IPV4}:5432/' benchmarksql-5.0/run/props.pg" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    SSH_CMD "cd benchmarksql-5.0/run;sh runDatabaseBuild.sh props.pg" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "cd benchmarksql-5.0/run;sh runBenchmark.sh props.pg &> /dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 2
    SSH_CMD "ps aux | grep -v grep | grep runBenchmark" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0
}

function clean_gauss_client() {
    SSH_CMD "ps aux | grep -v grep | grep runBenchmark | awk '{print $2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "cd benchmarksql-5.0/run;sh runDatabaseDestroy.sh props.pg" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "rm -rf benchmarksql-5.0.zip" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}
