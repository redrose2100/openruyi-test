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
# @Date      :   2023/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher guassdb
# #############################################
source common/gala-gopher.sh

function start_gauss_server() {
    yum install -y docker
    cat > /etc/docker/daemon.json << 'EOF'
{
"insecure-registries":["hub.oepkgs.net"]
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
    SSH_CMD "wget -q http://9.82.1.253/Public_Software_Tools/Aops/gala-gopher/benchmarksql-5.0.tar.gz" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "tar -xf benchmarksql-5.0.tar.gz" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
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
    SSH_CMD "rm -rf benchmarksql-5.0.tar.gz" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function pre_test() {
    start_gauss_server
    start_gauss_client
    start_gopher
}

function run_test() {
    #暂未改造
    if is_support_rest; then
        cat >> start_guass_probe.sh << EOF
    curl -X PUT http://localhost:9999/postgre_sli -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/pgsliprobe","check_cmd":""},"snoopers":{"container_id":["container_id1","container_id2"]},"params":{"report_event":1,"report_period":5,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
    curl -X PUT http://localhost:9999/opengauss_sli -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/pg_stat_probe.py","check_cmd":""},"snoopers":{"container_id":["container_id1","container_id2"]},"params":{"report_event":1,"report_period":5,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
EOF
        # 添加动态配置
        master_cid=$(docker ps | grep opengauss_master | awk '{print $1}')
        slave_cid=$(docker ps | grep opengauss_slave1 | awk '{print $1}')
        sed -i "s/container_id1/$master_cid/g" start_guass_probe.sh
        sed -i "s/container_id2/$slave_cid/g" start_guass_probe.sh
        sh -x start_guass_probe.sh

        #启动探针
        curl -X PUT http://localhost:9999/postgre_sli -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        curl -X PUT http://localhost:9999/opengauss_sli -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
    fi
    ps aux | grep "extend_probes\/pgsliprobe" | grep -v grep
    CHECK_RESULT $? 0 0
    ps aux | grep "extend_probes\/pg_stat_probe.py" | grep -v grep
    CHECK_RESULT $? 0 0

    sleep 60
    curl "$ETS_LOCAL_IP":8888 > gaussdb.txt
    cat gaussdb.txt | grep sli_rtt_nsec | grep 'POSTGRE' | grep "$gauss_port"
    expect_eq $? 0
    cat gaussdb.txt | grep sli_max_rtt_nsec | grep 'POSTGRE' | grep "$gauss_port"
    expect_eq $? 0
    cat gaussdb.txt | grep sli_tps | grep 'POSTGRE' | grep "$gauss_port"
    expect_eq $? 0
}

function post_test() {
    # clean env
    clean_gauss_server
    clean_gauss_client
    clean_gopher
}
main "$@"
