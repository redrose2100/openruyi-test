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
# @Desc      :   Test gala-gopher virt 物理机
# #############################################
source gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest; then
        # 添加动态配置
        curl -X PUT http://localhost:9999/virt -d json='{"cmd":{"bin":"virtualized_infos","check_cmd":""},"params":{"report_event":1,"report_period":5,"latency_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        #启动探针
        curl -X PUT http://localhost:9999/virt -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        #重启探针
        curl -X PUT http://localhost:9999/virt -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
    fi

    # check system_infos
    main_process=$(systemctl status gala-gopher | grep 'Main PID' | awk '{print $3}')
    ps -T -p "$main_process" | grep "\[PROBE\]virt"
    CHECK_RESULT $? 0 0

    # start iperf
    deploy_iperf
    systemctl stop firewalld
    stdbuf -oL iperf -V -s -p 5001 -i 1 &> log_iperf &
    SSH_CMD "iperf -c ${NODE1_IPV4} -i 1" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    curl "${NODE1_IPV4}":8888 > virtualized_infos

    cat virtualized_infos | grep gala_gopher_proc_value
    CHECK_RESULT $? 0 0
}

function post_test() {
    # clean env
    clean_iperf
    clean_gopher
}
main "$@"
