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

#shellcheck disable=SC2034,SC2155
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="360m"
    DNF_INSTALL "zlib gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel hwloc-devel kernel-headers glibc-headers elfutils-libelf-devel patch numactl tar automake cmake time psmisc vim git make"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    current_path=$(cd "$(dirname "$0")" || exit;pwd)
    branch=$(select_ltp_tag)
    until [ -e "ltp" ]
    do
        git clone -b "${branch}" https://github.com/linux-test-project/ltp.git
    done
    cd ltp || exit 1
    {
        make autotools 
        ./configure  
        make -j "$(nproc)"
        make install 
    } >>/dev/null 2>&1
    grep "openeulerversion" /etc/openEuler-latest |grep "22.03" && echo 1024 > /proc/dirty/buffer_size
    insmod /usr/lib/modules/"$(uname -r)"/kernel/fs/proc/etmem_swap.ko*
    insmod /usr/lib/modules/"$(uname -r)"/kernel/fs/proc/etmem_scan.ko*
    LOG_INFO "End to prepare the test environment."
}
select_ltp_tag() {
    local k=$(uname -r | awk -F. '{printf "%d%02d",$1,$2}')
    case $k in
        4*|509|510) echo 20220121 ;;
        511|6[0-4]) echo 20230626 ;;
        6[5-8])    echo 20231030 ;;
        *)         GIT_SSL_NO_VERIFY=true git ls-remote --tags --sort=-v:refname https://github.com/linux-test-project/ltp.git \
                   | awk -F/ '{print $3}' | grep -E '^[0-9]{8}$' | head -1 ;;
    esac
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /opt/ltp || exit 1
    ./runltp |tee -a ltp.txt
    grep -nr "FAIL" /opt/ltp/results |tee "${current_path}"/fail_cases.txt
    grep -nr "FAIL" /opt/ltp/results/|grep -v -E "af_alg07|cpufreq_boost|proc01|ioctl_sg01|madvise06|cpuset_memory_spread|cve-2018-1000204|cve-2017-1000364|cgroup|fanotify14|memcontrol02|starvation|memcg_stat_rss|cpuhotplug04|hugemmap10|cpuhotplug04|cpufreq_boost|cve-2019-8912|cpuset_load_balance|fs_fill|memcg_stress|"
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
