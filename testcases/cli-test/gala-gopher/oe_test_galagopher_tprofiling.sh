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
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162
source common/gala-gopher.sh

function pre_test() {
    docker ps | grep kafka || start_kafka
    start_gopher
}

function run_test() {
    if is_support_rest; then
        curl -X PUT http://localhost:9999/tprofiling -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tprofiling","probe":["oncpu","syscall_lock","syscall_file","syscall_net","syscall_sched"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"","debugging_dir":""}]},"state":"running"}'
        CHECK_RESULT $? 0 0
    fi
    ps aux | grep "extend_probes\/tprofiling" | grep -v grep
    CHECK_RESULT $? 0 0

    #consume kafka data
    pip3 config set global.index-url http://mirrors.tools.huawei.com/pypi/simple/
    pip3 config set global.trusted-host mirrors.tools.huawei.com
    pip3 install kafka kafka-python
    stdbuf -oL python ./common/kafka_meta.py &> kafka.txt &

    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    stdbuf -oL iperf -V -s -p 5002 -i 1 &> log_iperf &
    sleep 2
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 60" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 60 -p 5002" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    pid1=$(ps aux | grep iperf | grep -v grep | grep 5001 | awk '{print $2}')
    pid2=$(ps aux | grep iperf | grep -v grep | grep 5002 | awk '{print $2}')

    # oncpu syscall_lock syscall_file syscall_net
    events="oncpu sched lock net"
    for event in $events; do
        cat kafka.txt | grep -a "\"event.type\":\"$event\""
        CHECK_RESULT $? 0 0
    done
    for pid in $pid1 $pid2; do
        cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"net\"" | grep -a "\"event.name\":\"recvfrom\""
        CHECK_RESULT $? 0 0
        cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"lock\"" | grep -a "\"event.name\":\"futex\""
        CHECK_RESULT $? 0 0
        cat kafka.txt | grep -a "$pid" | grep -a "\"event.type\":\"sched\"" | grep -a "\"event.name\":\"clock_nanosleep\""
        CHECK_RESULT $? 0 0
    done

    #客户端
    > kafka.txt
    pkill -9 iperf
    SSH_CMD "pkill -9 iperf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 2
    iperf -c "${NODE2_IPV4}" -i 1 -t 60
    cat kafka.txt | grep -a iperf | grep -a "\"event.type\":\"net\"" | grep -a "\"event.name\":\"write\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a iperf | grep -a "\"event.type\":\"lock\"" | grep -a "\"event.name\":\"futex\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a iperf | grep -a "\"event.type\":\"sched\"" | grep -a "\"event.name\":\"clock_nanosleep\""
    CHECK_RESULT $? 0 0
    cat kafka.txt | grep -a iperf | grep -a "\"event.type\":\"oncpu\"" | grep -a "\"event.name\":\"oncpu\""
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
    SSH_SCP common/udptest.py "${NODE2_USER}"@"${NODE2_IPV4}":/root "${NODE2_PASSWORD}"
    SSH_CMD "python udptest.py --clientip=${NODE1_IPV4} --port=$port &>/dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 30
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
    cd common
    java JavaOOMHttpServer 8007 &
    pid=$!
    cd -
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
    rm -rf kafka.txt
    ps aux | grep kafka_meta.py | grep -v grep | awk '{print $2}' | xargs kill -9
    clean_gopher
}
main "$@"
