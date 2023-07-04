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
# @Desc      :   Test gala-gopher taskprobe
# #############################################
source ../common/gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest;then
        # 添加动态配置
        curl -X PUT http://localhost:9999/proc -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/taskprobe","check_cmd":"","probe":["base_metrics","proc_syscall","proc_fs","proc_io","proc_dns","proc_pagecache"]},"snoopers":{"proc_name":[{"comm":"python","cmdline":"","debugging_dir":""},{"comm":"iperf","cmdline":"","debugging_dir":""},{"comm":"dd","cmdline":"","debugging_dir":""}]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        #启动探针
        curl -X PUT http://localhost:9999/proc -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/taskprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    else
        # check task_probe
        ps aux | grep "extend_probes\/taskprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    fi    

    #start udp
    port=$(get_unused_port)
    python common/udptest.py --serverip="${NODE1_IPV4}" --port="$port" &> /dev/null &
    sleep 2
    SSH_SCP common/udptest.py ${NODE2_USER}@${NODE2_IPV4}:/root ${NODE2_PASSWORD}
    SSH_CMD "python udptest.py --clientip=${NODE1_IPV4} --port=$port &>/dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    pid=$(ps aux | grep -v grep | grep udptest.py | awk '{print $2}')

    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    sleep 2
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 60" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    curl "${NODE1_IPV4}":8888 > taskprobe.txt
    while read line; do
        cat taskprobe.txt | grep -a "$pid" | grep -a python | grep -a proc_"$line"
        [ $? -eq 0 ] || echo "proc:$line not exist" >> fail_log
    done < metrics/process_metric
    check_log

    #TODO涉及读写操作
    #TODO大量指标未覆盖
    process_metric_wr="ns_ext4_read ns_ext4_write ns_ext4_flush ns_ext4_open"
    while read line; do
        cat taskprobe.txt | grep proc_"$metric"
        expect_eq $? 0 || echo "proc:$line not exist" >> fail_log
    done < metrics/process_metric_wr
}

function post_test() {
    # clean env
    mv "$GOPHER_CONF_PATH".bak "$GOPHER_CONF_PATH"
    clean_iperf
    ps aux | grep udptest.py | grep -v grep | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps aux | grep udptest.py | grep -v grep | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    clean_gopher
}
main "$@"
