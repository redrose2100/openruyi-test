#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2. 
# You can use it according to the terms and conditions of the Mulan PSL v2. 
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023.06.30
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite
# ############################################

#shellcheck disable=SC2034,SC2155,SC2120
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="600m"
    DNF_INSTALL "zlib gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel hwloc-devel kernel-headers glibc-headers elfutils-libelf-devel patch numactl tar automake cmake time psmisc vim git make"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    current_path=$(cd "$(dirname "$0")" || exit;pwd)
    branch=$(select_ltp_tag)
    until [ -e "ltp" ]
    do
        git clone -b "${branch}" https://github.com/linux-test-project/ltp.git
    done
    cp "${current_path}/memcg_move_charge_at_immigrate_test.sh" \
       ltp/testcases/kernel/controllers/memcg/functional/memcg_move_charge_at_immigrate_test.sh
    cp "${current_path}/memcg_lib.sh" ltp/testcases/kernel/controllers/memcg/functional/memcg_lib.sh
    cp "${current_path}/memcg_subgroup_charge.sh" ltp/testcases/kernel/controllers/memcg/functional/memcg_subgroup_charge.sh
    cd ltp || exit 1
    {
        make autotools 
        ./configure  
        make -j "$(nproc)"
        make install 
    } >>/dev/null 2>&1
    # proc01 相关配置
    if [[ -f "/proc/dirty/buffer_size" ]]; then
        echo 1024 > /proc/dirty/buffer_size
    fi

    # 加载内核模块（如果存在）
    local ko_path="/usr/lib/modules/$(uname -r)/kernel/fs/proc/"
    if [[ -f "${ko_path}/etmem_swap.ko" ]]; then
        insmod "${ko_path}/etmem_swap.ko" 2>/dev/null
    fi
    if [[ -f "${ko_path}/etmem_scan.ko" ]]; then
        insmod "${ko_path}/etmem_scan.ko" 2>/dev/null
    fi

    # cve-2025-21756用例依赖vsock_loopback.ko
    modprobe vsock_loopback

    # Starvation 配置
    if [[ -f "/sys/kernel/debug/sched/features" ]]; then
        echo NO_RUN_TO_PARITY_WAKEUP > /sys/kernel/debug/sched/features 2>/dev/null
    fi

    # 关闭SELinux 
    setenforce 0

    LOG_INFO "End to prepare the test environment."
}

select_ltp_tag() {
    local k=$(uname -r | awk -F. '{printf "%d%02d",$1,$2}')
    local default_tag="20260130"
    local mirror="https://ghproxy.com/https://github.com/linux-test-project/ltp.git"

    case $k in
        419|510)    echo 20220121 ;;
        606)        echo 20260130 ;;
        *)
            local tag=""
            for url in "https://github.com/linux-test-project/ltp.git" "$mirror"; do
                tag=$(GIT_SSL_NO_VERIFY=true git ls-remote --tags --sort=-v:refname \
                      "$url" 2>/dev/null \
                      | awk -F/ '{print $3}' | grep -E '^[0-9]{8}$' | head -1)
                [[ -n "$tag" ]] && break
            done
            echo "${tag:-$default_tag}"
            ;;
    esac
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /opt/ltp || exit 1
    ./runltp |tee -a ltp.txt
    grep -nr "FAIL" /opt/ltp/results |tee "${current_path}"/fail_cases.txt
    grep -nr "FAIL" /opt/ltp/results/|grep -v -E "cpufreq_boost|proc01|cpuset_memory_spread|fanotify14|memcg_stat_rss|cpuhotplug04|hugemmap10|cve-2019-8912|cpuset_load_balance|file_attr01|file_attr02|file_attr04|lock_torture"
    CHECK_RESULT $? 1 0 "any case failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    cd "${current_path}" || exit 1
    rm -rf "${current_path}"/ltp /opt/ltp
    LOG_INFO "End to restore the test environment."
}

main "$@"

