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
# @Desc      :   Test gala-gopher ioprobe
# #############################################
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162
source common/gala-gopher.sh

function pre_test() {
    start_gopher
}

function run_test() {
    if is_support_rest; then
        curl -X PUT http://localhost:9999/io -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/ioprobe","check_cmd":"","probe":["io_trace","io_err","io_count","page_cache"]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        curl -X PUT http://localhost:9999/io -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
    fi
    ps aux | grep "extend_probes\/ioprobe" | grep -v grep
    CHECK_RESULT $? 0 0

    dd if=/dev/zero of=test_1.txt bs=100M count=1 conv=fsync

    curl "${NODE1_IPV4}":8888 > ioprobe.txt
    while read line; do
        cat ioprobe.txt | grep block_"$line"
        [ $? -eq 0 ] && echo "block:$line" >> fail_log
    done < metrics/block_metric
    check_log
}

function post_test() {
    # clean env
    rm -rf test_1.txt fail_log
    clean_gopher
}
main "$@"
