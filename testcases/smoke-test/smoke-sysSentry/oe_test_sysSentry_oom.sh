#!/usr/bin/bash
# shellcheck disable=SC1091,SC2154
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   yangna 
# @Date      :   2025/12/12
# ##################################


source "comm/lib.sh"
set -x

function pre_test(){
    pre_oom_env
}

function test_hugepages() {
    echo 3 > /proc/sys/vm/drop_caches

    total_mem_kb=$(free -k | grep Mem | awk '{print $2}')
    hugepage_size_kb=2048  # 2MB
    # 触发OOM需要占用95%以上的内存
    # 保留5%给系统关键进程
    oom_threshold=$((total_mem_kb * 95 / 100))
    # 计算需要的hugepages数量
    needed_hugepages=$((oom_threshold / hugepage_size_kb))
    echo "总内存: $((total_mem_kb / 1024 / 1024)) GB"
    echo "OOM阈值(95%): $((oom_threshold / 1024 / 1024)) GB"
    echo "需要的hugepages: $needed_hugepages"
    # 但是直接设置这个值可能会卡死！使用timeout
    timeout 5 bash -c "echo $needed_hugepages > /proc/sys/vm/nr_hugepages"
}
function run_test(){

    sentryctl set sentry_reporter --oom=on
    test_hugepages
    start_RA oom
    CHECK_RESULT $? 0 0

    check_oom_dmesg 1 1
    CHECK_RESULT $? 0 0

    check_RA_oom 1 1
    CHECK_RESULT $? 0 0

    check_alarmd 1005 71 " " 3
    CHECK_RESULT $? 0 0

    check_oom_sentry_msg_monitor 1 1 true
    CHECK_RESULT $? 0 0
}
function post_test(){
    clean_sysSentry_message
}

main "$@"
