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
# @Desc      :   Test gala-gopher redis
# #############################################
source common/gala-gopher.sh

function pre_test() {
    start_gopher
    start_redis
    SSH_CMD "which gala-gopher || yum install -y gala-gopher" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function run_test() {
    if is_support_rest; then
        # 添加动态配置 ksliprobe 不使用snoopers
        curl -X PUT http://localhost:9999/ksli -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/ksliprobe","check_cmd":""},"params":{"report_event":1,"report_period":5,"latency_thr":10,"drops_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"],"continuous_sampling":1}}'
        #启动探针
        curl -X PUT http://localhost:9999/ksli -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/ksliprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    else
        cp "$GOPHER_CONF_PATH" "${GOPHER_CONF_PATH}.bak"
        line=$(grep -nr "ksliprobe" "$GOPHER_CONF_PATH" | grep command | awk -F: '{print $1}')
        sed -i "$((line + 1))s/param = \"\"/param = \"-C\"/g" "$GOPHER_CONF_PATH"
        systemctl restart gala-gopher
        # check ksliprobe
        ps aux | grep "extend_probes\/ksliprobe" | grep -v grep
        CHECK_RESULT $? 0 0

    fi

    SSH_CMD "python3 /opt/gala-gopher/extend_probes/client-async.py -h ${NODE1_IPV4} -p 6379 -q 1000 &> /dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 10
    curl "$ETS_LOCAL_IP":8888 > redis.txt
    cat redis.txt | grep sli_rtt_nsec | grep REDIS | grep GET
    CHECK_RESULT $? 0 0
    cat redis.txt | grep sli_max_rtt_nsec | grep REDIS | grep GET
    CHECK_RESULT $? 0 0
    SSH_CMD "ps aux | grep client-async.py | grep -v grep | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    SSH_CMD "python3 /opt/gala-gopher/extend_probes/client-async.py -h ${NODE1_IPV4} -p 6379 -q 1000 -t set &> /dev/null &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 10
    curl "$ETS_LOCAL_IP":8888 > redis.txt
    cat redis.txt | grep sli_rtt_nsec | grep REDIS | grep SET
    CHECK_RESULT $? 0 0
    cat redis.txt | grep sli_max_rtt_nsec | grep REDIS | grep SET
    CHECK_RESULT $? 0 0
    SSH_CMD "ps aux | grep client-async.py | grep -v grep | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    redis-benchmark -h "${NODE1_IPV4}" -p 6379 ping
    curl "${NODE1_IPV4}":8888 > redis.txt
    cat redis.txt | grep sli_rtt_nsec | grep REDIS | grep PIN
    CHECK_RESULT $? 0 0
    cat redis.txt | grep sli_max_rtt_nsec | grep REDIS | grep PIN
    CHECK_RESULT $? 0 0
}

function post_test() {
    # clean env
    clean_redis
    clean_gopher
}
main "$@"
