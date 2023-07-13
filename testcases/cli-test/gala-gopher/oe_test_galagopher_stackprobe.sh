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
# @Desc      :   Test gala-gopher stackprobe
# #############################################
source ./common/gala-gopher.sh

function start_pyroscope() {
    #wget https://dl.pyroscope.io/release/pyroscope-0.35.1-1-x86_64.rpm
    #yum localinstall pyroscope-0.35.1-1-x86_64.rpm
    pyroscope_rpm=$(ls common | grep pyroscope | grep "$(arch)")
    rpm -ivh common/"$pyroscope_rpm"
    cp /usr/lib/pyroscope/scripts/pyroscope-server.service /usr/lib/systemd/system/
    systemctl start pyroscope-server
    netstat -natpl | grep pyroscope | grep 4040
    CHECK_RESULT $? 0 0
}

function pre_test() {
    start_gopher
    start_pyroscope
}

function run_test() {
    if is_support_rest; then
        curl -X PUT http://localhost:9999/flamegraph -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/stackprobe","check_cmd":"","probe":["oncpu","offcpu","mem"]},"snoopers":{"proc_name":[{"comm":"iperf","cmdline":"","debugging_dir":""}]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"drops_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        curl -X PUT http://localhost:9999/flamegraph -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/stackprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    else
        # check stack_probe
        ls "$GOPHER_CONF_PATH".bak || cp "$GOPHER_CONF_PATH" "$GOPHER_CONF_PATH".bak
        line=$(grep -nr stackprobe "${gala_path}" | grep command | awk -F: '{print $1}')
        sed -i '$((line + 2))s/off/on/g' "${gala_path}"
        systemctl restart gala-gopher
        ps aux | grep "extend_probes\/stackprobe" | grep -v grep
        CHECK_RESULT $? 0 0

        conf_path="/etc/gala-gopher/extend_probes/stackprobe.conf"
        cp "${conf_path}" "${conf_path}.bak"
        sed -i 's/oncpu = .*;/oncpu = true;/g' "${conf_path}"
        sed -i 's/offcpu = .*;/offcpu = true;/g' "${conf_path}"
        sed -i 's/memleak = .*;/memleak = true;/g' "${conf_path}"
        stdbuf -oL "$stackprobe_path" > stackprobe.log 2>&1 &
    fi
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 10" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    # collect iperf num
    for ((i = 0; i < 10; i++)); do
        p_num=$(grep -A 1 'P_CACHE' /var/log/gala-gopher/debug/gopher.log | tail -1 | awk '{print $(NF-1)}')
        [ "$p_num" -eq 1 ] && break
        sleep 4
    done
    [ "$i" -lt 10 ]
    CHECK_RESULT $? 0 0

    # start iperf after probe
    for ((i = 0; i < 130; i++)); do
        stdbuf -oL iperf -V -s -p $((5001 + i)) -i 1 &> log_iperf &
        sleep 0.1
    done
    sleep 10
    for ((i = 0; i < 130; i++)); do
        SSH_CMD "iperf -c ${NODE1_IPV4} -i 1 -t 5 -p $((5001 + i))" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    done

    for metric in "oncpu offcpu mem"; do
        grep 'curl post post to http://localhost:4040' /var/log/gala-gopher/debug/gopher.log | grep gala-gopher-"$metric"
        CHECK_RESULT $? 0 0
    done
    # collect iperf num
    for ((i = 0; i < 10; i++)); do
        p_num=$(grep -A 1 'P_CACHE' /var/log/gala-gopher/debug/gopher.log | tail -1 | awk '{print $(NF-1)}')
        [ "$p_num" -eq 100 ] && break
        sleep 4
    done
    [ "$i" -lt 10 ]
    CHECK_RESULT $? 0 0

    for ((i = 0; i < 10; i++)); do
        p_num=$(grep -A 1 'PCACHE_CRT' /var/log/gala-gopher/debug/gopher.log | tail -1 | awk '{print $10}')
        [ "$p_num" -ge 100 ] && break
        sleep 4
    done
    [ "$i" -lt 10 ]
    CHECK_RESULT $? 0 0
}

function post_test() {
    # clean env
    ls "$GOPHER_CONF_PATH".bak || mv "$GOPHER_CONF_PATH".bak "$GOPHER_CONF_PATH"
    clean_iperf
    clean_gopher
    > fail_log
}
main "$@"
