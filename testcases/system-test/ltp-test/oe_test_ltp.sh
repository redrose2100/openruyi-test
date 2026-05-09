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
# @Author    :   hanson_fang & dingjiao
# @Contact   :   490538494@qq.com
# @Date      :   2026.05.09
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite (modified for src-openeuler)
# ############################################

#shellcheck disable=SC2034,SC2155
source "$OET_PATH/libs/locallibs/common_lib.sh"

LTP_SRC_DIR=""

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="360m"
    DNF_INSTALL "zlib gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel hwloc-devel kernel-headers glibc-headers elfutils-libelf-devel patch numactl tar automake cmake time psmisc vim git make wget"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    current_path=$(cd "$(dirname "$0")" || exit;pwd)
    
    
    # 根据内核版本选择对应的 LTP 版本
    select_ltp_version
    
    LOG_INFO "End to prepare the test environment."
}

select_ltp_version() {
    local kernel_version=$(uname -r | awk -F '-' '{print $1}')
    LOG_INFO "Current kernel version: ${kernel_version}"
    
    # 判断内核版本是否为 6.6.0，使用新版 LTP-20260130
    if [[ "${kernel_version}" == "6.6.0" ]]; then
        LOG_INFO "Kernel version 6.6.0 detected, using LTP-20260130 (modified version)"
        download_ltp_from_tar "20260130"
    else
        LOG_INFO "Kernel version ${kernel_version} detected, using LTP-20210121"
        download_ltp_from_tar "20210121"
    fi
}

download_ltp_from_tar() {
    local version=$1
    local tar_url="https://atomgit.com/src-openeuler/linux-test-project/blob/master/ltp-${version}.tar.gz"
    local tar_file="${current_path}/ltp-${version}.tar.gz"
    
    LOG_INFO "Downloading LTP ${version} from ${tar_url}"
    
    # 下载 tar.gz 包
    wget --no-check-certificate -O "${tar_file}" "${tar_url}"
    if [[ $? -ne 0 ]]; then
        LOG_ERROR "Failed to download LTP ${version} tar.gz"
        exit 1
    fi
    
    # 解压到当前目录
    LOG_INFO "Extracting ${tar_file} to ${current_path}"
    tar -xzf "${tar_file}" -C "${current_path}"
    if [[ $? -ne 0 ]]; then
        LOG_ERROR "Failed to extract ${tar_file}"
        exit 1
    fi
    
    # 查找解压后的目录名
    local extracted_dir=$(find "${current_path}" -maxdepth 1 -type d \( -name "ltp-${version}" -o -name "linux-test-project*" \) | head -1)
    if [[ -z "${extracted_dir}" ]]; then
        LOG_ERROR "Cannot find extracted LTP directory"
        exit 1
    fi
    
    # 记录解压后的目录路径，不重命名
    LTP_SRC_DIR="${extracted_dir}"
    LOG_INFO "Successfully extracted LTP ${version} to ${LTP_SRC_DIR}"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # 编译 LTP
    LOG_INFO "Building LTP from ${LTP_SRC_DIR}..."
    cd "${LTP_SRC_DIR}" || exit 1
    {
        make autotools
        ./configure --prefix=/opt/ltp
        make -j "$(nproc)"
        make install
    } >> "${current_path}/ltp_build.log" 2>&1
    
    if [[ $? -ne 0 ]]; then
        LOG_ERROR "LTP build failed, check ${current_path}/ltp_build.log"
        exit 1
    fi
    
    LOG_INFO "LTP successfully installed to /opt/ltp"
    
    # proc01 相关配置
    if [[ -f "/proc/dirty/buffer_size" ]]; then
        echo 1024 > /proc/dirty/buffer_size
        LOG_INFO "Configured /proc/dirty/buffer_size"
    fi
    
    # 加载内核模块（如果存在）
    local ko_path="/usr/lib/modules/$(uname -r)/kernel/fs/proc/"
    if [[ -f "${ko_path}/etmem_swap.ko" ]]; then
        insmod "${ko_path}/etmem_swap.ko" 2>/dev/null
        LOG_INFO "Loaded etmem_swap module"
    fi
    if [[ -f "${ko_path}/etmem_scan.ko" ]]; then
        insmod "${ko_path}/etmem_scan.ko" 2>/dev/null
        LOG_INFO "Loaded etmem_scan module"
    fi
    
    # Starvation 配置
    if [[ -f "/sys/kernel/debug/sched/features" ]]; then
        echo NO_RUN_TO_PARITY_WAKEUP > /sys/kernel/debug/sched/features 2>/dev/null
        LOG_INFO "Configured scheduler features"
    fi
    
    # 增加超时时间
    export LTP_TIMEOUT_MUL=10
    LOG_INFO "Set LTP_TIMEOUT_MUL=10"
    
    # 运行 LTP 测试
    cd /opt/ltp || exit 1
    LOG_INFO "Running LTP tests..."
    ./runltp 2>&1 | tee -a ltp.txt
    
    # 检查失败用例
    grep -nr "FAIL" /opt/ltp/results | tee "${current_path}/fail_cases.txt"
    
    # 忽略已知的预期失败用例
    grep -nr "FAIL" /opt/ltp/results/ | grep -v -E "af_alg07|cpufreq_boost|proc01|ioctl_sg01|cpuset_memory_spread|cgroup|fanotify14|memcg_stat_rss|cpuhotplug04|hugemmap10|cve-2019-8912|cpuset_load_balance|fs_fill"
    CHECK_RESULT $? 1 0 "any case failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}

    LOG_INFO "End to restore the test environment."
}

main "$@"
