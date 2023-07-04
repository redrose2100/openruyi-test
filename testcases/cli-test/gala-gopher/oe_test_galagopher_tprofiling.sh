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
# @Contact   :   1297248816@qq.com
# @Date      :   2023/06/30
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher tprofiling
# #############################################
source common/gala-gopher.sh


function start_kafka() {
    #配置docker镜像 安装kafka
    yum install -y docker

    touch /etc/docker/daemon.json
    cat > /etc/docker/daemon.json << 'EOF'
{
"registry-mirrors":["https://rnd-dockerhub.huawei.com"],
"insecure-registries":["rnd-dockerhub.huawei.com","hub.witcloud.huawei.com"]
}
EOF

    httpproxy="/etc/systemd/system/docker.service.d/"
    mkdir -p "${httpproxy}"
    touch "${httpproxy}"/http-proxy.conf
    cat > "${httpproxy}"/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://peulerosweb:EulerOS_123@proxyhk.huawei.com:8080"
Environment="HTTPS_PROXY=http://peulerosweb:EulerOS_123@proxyhk.huawei.com:8080"
Environment="http_proxy=http://peulerosweb:EulerOS_123@proxyhk.huawei.com:8080"
Environment="NO_PROXY=127.0.0.1,localhost,10.0.0.0/8,rnd-dockerhub.huawei.com,9.81.3.101:80,10.183.203.145:5000,mydockerhub.inhuawei.com,9.41.111.111:5000,my.csp-edge.com:5000,my.csp-edge.com,10.183.203.145,10.175.102.71,test.csp-edge.com,harbot.inhuawei.com"
EOF
    configure_proxy
    pon
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
    poff
}

function clean_kafka() {
    docker_ids=$(docker ps | grep -v CONTAINER | awk '{print $1}')
    for docker_id in $docker_ids; do
        docker stop "$docker_id"
        docker rm "$docker_id"
    done
    systemctl stop docker
}

function pre_test() {
    docker ps | grep kafka || start_kafka 
    start_gopher
}

function run_test() {
    if is_support_rest;then
	# 添加动态配置 启动探针
	curl -X PUT http://localhost:9999/tprofiling -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tprofiling","probe":["oncpu","syscall_lock","syscall_file","syscall_net","syscall_sched"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"","debugging_dir":""}]},"state":"running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/tprofiling" | grep -v grep
	CHECK_RESULT $? 0 0
    else
        # check tprofiling
        ps aux | grep "extend_probes\/tprofiling" | grep -v grep 
        CHECK_RESULT $? 0 0
    fi
    #consume kafka data
    pip3 config set global.index-url http://mirrors.tools.huawei.com/pypi/simple/
    pip3 config set global.trusted-host mirrors.tools.huawei.com
    pip3 install kafka kafka-python
    stdbuf -oL python ./common/kafka_meta.py &> kafka.txt &

    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    sleep 2
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 60" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    # 事件 oncpu syscall_lock syscall_file syscall_net
    events="oncpu sched lock net"
    for event in $events ;do
	cat kafka.txt | grep -a "\"event.type\":\"$event\""
	CHECK_RESULT $? 0 0
    done
    cat kafka.txt | grep -a "\"event.type\":\"net\"" | grep -a "\"event.name\":\"recvfrom\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a "\"event.type\":\"lock\"" | grep -a "\"event.name\":\"futex\""
    CHECK_RESULT $? 0 0 
    cat kafka.txt | grep -a "\"event.type\":\"sched\"" | grep -a "\"event.name\":\"clock_nanosleep\""
    CHECK_RESULT $? 0 0


    #客户端
    > kafka.txt
    pkill -9 iperf
    SSH_CMD "pkill -9 iperf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 2
    iperf -c ${NODE2_IPV4} -i 1 -t 60
    cat kafka.txt | grep -a "\"event.type\":\"net\"" | grep -a "\"event.name\":\"write\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a "\"event.type\":\"lock\"" | grep -a "\"event.name\":\"futex\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a "\"event.type\":\"sched\"" | grep -a "\"event.name\":\"clock_nanosleep\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a "\"event.type\":\"oncpu\"" | grep -a "\"event.name\":\"oncpu\""
    CHECK_RESULT $? 0 0 
    clean_iperf

    #python进程
    > kafka.txt
    curl -X PUT http://localhost:9999/tprofiling -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tprofiling","probe":["oncpu","syscall_lock","syscall_file","syscall_net","syscall_sched"]},"snoopers":{"proc_name":[{"comm":"python","cmdline":"udptest.py","debugging_dir":""}]},"state":"running"}'
    CHECK_RESULT $? 0 0
    ps aux | grep "extend_probes\/tprofiling" | grep -v grep
    CHECK_RESULT $? 0 0
    port=$(get_unused_port)
    python common/udptest.py --serverip="${NODE1_IPV4}" --port="$port" &> /dev/null &
    pid=$!
    sleep 2
    SSH_SCP common/udptest.py ${NODE2_USER}@${NODE2_IPV4}:/root ${NODE2_PASSWORD}
    SSH_CMD "python udptest.py --clientip=${NODE1_IPV4} --port=$port &>/dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 10
    cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"net\"" | grep -a "\"event.name\":\"recvfrom\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"oncpu\"" | grep -a "\"event.name\":\"oncpu\""
    CHECK_RESULT $? 0 0
    ps aux | grep udptest.py | grep -v grep | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps aux | grep udptest.py | grep -v grep | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    #java进程
    > kafka.txt
    curl -X PUT http://localhost:9999/tprofiling -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tprofiling","probe":["oncpu","syscall_lock","syscall_file","syscall_net","syscall_sched"]},"snoopers":{"proc_name":[{"comm":"java","cmdline":"JavaOOMHttpServer","debugging_dir":""}]},"state":"running"}'
    CHECK_RESULT $? 0 0
    ps aux | grep "extend_probes\/tprofiling" | grep -v grep
    CHECK_RESULT $? 0 0
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel javassist
    ls common/JavaOOMHttpServer.class || javac -classpath /usr/share/java/javassist.jar common/JavaOOMHttpServer.java
    java JavaOOMHttpServer 8007 &
    pid=$!
    sleep 1
    ps aux | grep 'java JavaOOMHttpServer' | grep -v grep
    CHECK_RESULT $? 0 0
    sleep 10
    cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"lock\"" | grep -a "\"event.name\":\"futex\""
    CHECK_RESULT $? 0 0
    kill -9 "$pid"
}

function post_test() {
    # clean env
    ps aux | grep kafka_meta.py | grep -v grep | awk '{print $2}' | xargs kill -9
    clean_gopher
}
main "$@"
