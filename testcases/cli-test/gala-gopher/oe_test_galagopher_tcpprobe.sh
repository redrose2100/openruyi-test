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
# @Desc      :   Test gala-gopher tcpprobe
# #############################################
source common/gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest; then
        # 添加动态配置
        curl -X PUT http://localhost:9999/tcp -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tcpprobe","check_cmd":"","probe":["tcp_rtt","tcp_srtt","tcp_abnormal","tcp_windows","tcp_rate","tcp_sockbuf","tcp_stats"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"","debugging_dir":""}]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"drops_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        #curl -X PUT http://localhost:9999/tcp -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/tcpprobe","check_cmd":"","probe":["tcp_rtt","tcp_srtt","tcp_abnormal","tcp_windows","tcp_rate","tcp_sockbuf","tcp_stats"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"iperf-V-s-p5001-i1","debugging_dir":""}]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"drops_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        # 启动探针
        curl -X PUT http://localhost:9999/tcp -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/tcpprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    else
        # check tcp_probe
        ls "$GOPHER_CONF_PATH".bak || cp "$GOPHER_CONF_PATH" "$GOPHER_CONF_PATH".bak
        sed -i 's/warn -P .*"/warn -P ffff"/g' "$GOPHER_CONF_PATH"
        systemctl restart gala-gopher
        ps aux | grep "extend_probes\/tcpprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    fi
    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    sleep 2
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 20" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #20s没有tcp_rate 60s有tcp_rate
    curl "${NODE1_IPV4}":8888 > tcp.txt
    while read line; do
        cat tcp.txt | grep tcp_link_"$line"
        [ $? -eq 0 ] || echo "tcp:$line" >> fail_log
    done < metrics/tcp_metric
    check_log
}

function post_test() {
    # clean env
    ls "$GOPHER_CONF_PATH".bak || mv "$GOPHER_CONF_PATH".bak "$GOPHER_CONF_PATH"
    clean_iperf
    clean_gopher
}
main "$@"
