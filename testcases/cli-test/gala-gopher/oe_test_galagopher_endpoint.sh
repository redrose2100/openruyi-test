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
# @Date      :   2023/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher endpoint
# #############################################
source common/gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest;then
        # 添加动态配置
	curl -X PUT http://localhost:9999/socket -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/endpoint","check_cmd":"","probe":["tcp_socket","udp_socket"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"","debugging_dir":""}]},"params":{"report_event":1,"report_period":5}}'
        #启动探针
        curl -X PUT http://localhost:9999/socket -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
    fi
    # check endpoint probe
    ps aux | grep "extend_probes\/endpoint" | grep -v grep
    CHECK_RESULT $? 0 0

    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    sleep 2
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 20" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    # endpoint探针获取tcp server指标数据
    curl "${NODE1_IPV4}":8888 > endpoint_server.txt
    endpoint_tcp_listen="listendrop accept_overflow accept_overflow passive_open passive_open_failed retran_synacks lost_synacks"
    for metric in $endpoint_tcp_listen; do
        cat endpoint_server.txt | grep "$iperf_port" | grep listen | grep endpoint_$metric
        [ $? -eq 0 ] || echo "endpoint:$metric" >> fail_log
    done

    #endpoint探针获取tcp client指标数据
    pkill -9 iperf
    SSH_CMD "iperf -V -s -p 5001 -i 1 &>/dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl stop firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 2
    iperf -c "${NODE2_IPV4}" -i 1 -t 20
    curl "$ETS_LOCAL_IP":8888 > endpoint_client.txt
    endpoint_tcp_connect="active_open active_open_failed"
    for metric in $endpoint_tcp_connect; do
        cat endpoint_client.txt  | grep connect | grep endpoint_$metric
        [ $? -ne 0 ] || echo "endpoint:$metric" >> fail_log
    done

    systemctl restart gala-gopher
    if is_support_rest;then
	curl -X PUT http://localhost:9999/socket -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/endpoint","check_cmd":""},"probes":{"probe":["tcp_socket","udp_socket"],"proc_name":[{"comm":"python","cmdline":"","debugging_dir":""}]},"params":{"report_event":1,"report_period":5}}'
        curl -X PUT http://localhost:9999/socket -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/endpoint" | grep -v grep
        CHECK_RESULT $? 0 0
    fi
    port=$(get_unused_port)
    python common/udptest.py --serverip="${NODE1_IPV4}" --port="$port" &> /dev/null &
    SSH_SCP common/udptest.py ${NODE2_USER}@${NODE2_IPV4}:/root ${NODE2_PASSWORD}
    SSH_CMD "python udptest.py --clientip=${NODE1_IPV4} --port=$port &>/dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 10
    curl $ETS_LOCAL_IP:8888 > endpoint_udp_server.txt
    server_pid=$(ps aux | grep -v grep | grep udptest.py | awk '{print $2}')
    endpoint_udp="udp_rcv_drops udp_sends udp_rcvs udp_err"
    endpoint_bind="bind_rcv_drops bind_sends bind_rcvs bind_err"
    endpoint_udp_bind="$endpoint_udp $endpoint_bind"
    for metric in $endpoint_udp_bind; do
        cat endpoint_udp_server.txt | grep $server_pid | grep endpoint_$metric
        [ $? -eq 0 ] || echo "endpoint:$metric" >> fail_log
    done
    
    cat fail_log | wc -l | grep 0
    CHECK_RESULT $? 0 0
    cat fail_log #debug
}

function post_test() {
    # clean env
    clean_iperf
    ps aux | grep udptest.py | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps aux | grep udptest.py | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    clean_gopher
}
main "$@"
