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
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162
source common/gala-gopher.sh

function pre_test() {
    start_gauss_server
    start_gauss_client
    start_gopher
}

function run_test() {
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
    gauss_port=5432
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
