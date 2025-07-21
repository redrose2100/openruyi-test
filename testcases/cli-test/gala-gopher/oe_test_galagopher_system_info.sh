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
# @Date      :   2023/06/28
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher system_infos
# #############################################
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162
source common/gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest; then
        curl -X PUT http://localhost:9999/baseinfo -d json='{"cmd":{"bin":"system_infos","check_cmd":"","probe":["proc","fs","disk","net","nic","mem","cpu","host"]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        curl -X PUT http://localhost:9999/baseinfo -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
    fi

    # check system_infos
    main_process=$(systemctl status gala-gopher | grep 'Main PID' | awk '{print $3}')
    ps -T -p "$main_process" | grep "\[PROBE\]baseinfo"
    CHECK_RESULT $? 0 0

    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf3 -V -s -p 5001 -i 1 &> log_iperf &
    SSH_CMD "iperf3 -c ${NODE1_IPV4} -i 1" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    curl "${NODE1_IPV4}":8888 > system_info

    while read line; do
        cat system_info | grep cpu | grep "$line"
        [ $? -eq 0 ] || echo "cpu:$line not exist" >> fail_log
    done < metrics/cpu_metric
    while read line; do
        cat system_info | grep disk | grep "$line"
        [ $? -eq 0 ] || echo "disk:$line not exist" >> fail_log
    done < metrics/disk_metric
    while read line; do
        cat system_info | grep nic | grep "$line"
        [ $? -eq 0 ] || echo "nic:$line not exist" >> fail_log
    done < metrics/nic_metric
    while read line; do
        cat system_info | grep net | grep "$line"
        [ $? -eq 0 ] || echo "net:$line not exist" >> fail_log
    done < metrics/net_metric
    while read line; do
        cat system_info | grep mem | grep "$line"
        [ $? -eq 0 ] || echo "mem:$line not exist" >> fail_log
    done < metrics/mem_metric
    while read line; do
        cat system_info | grep fs | grep "$line" | grep MountOn | grep Fsname | grep Fstype | grep Inodes | grep Inodes
        [ $? -eq 0 ] || echo "fs:$line not exist" >> fail_log
    done < metrics/fs_metric
    while read line; do
        cat system_info | grep host | grep "$line" | grep os_version | grep hostname | grep kversion | grep cpu_num | grep memory_MB | grep ip_addr
        [ $? -eq 0 ] || echo "host:$line not exist" >> fail_log
    done < metrics/host_metric
    check_log
}

function post_test() {
    # clean env
    clean_iperf
    clean_gopher
}
main "$@"
