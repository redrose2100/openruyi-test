#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2023-01-17 16:44:43
#@License   	:   Mulan PSL v2
#@Desc      	:   run ltp test
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

CUR_DATE=$(date +'%Y-%m-%d %H:%M:%S')
CUR_DIR=$(
        cd "$(dirname "$0")" || exit 1
        pwd
)
TOP_DIR=$(echo "$CUR_DIR" | cut -d'/' -f1-2)

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    EXECUTE_T="1440m"

    MAKEDIR=$(cd .. && pwd)
    chmod 777 "${MAKEDIR}"/make
    MAKE="${MAKEDIR}"/make
    echo "MAKE = ${MAKE}"

    timestap=$(stat -c %Y tmp_test/allinfo.tar)
    formart_date=$(date '+%Y-%m-%d %H:%M:%S' -d @"$timestap")
    date -s "$formart_date"

    # 备份将被 sysroot 覆盖的系统库目录，避免 ABI 不匹配导致系统服务崩溃
    BACKUP_TAR=/root/.ltp_sysroot_backup.tar
    tar -cf "$BACKUP_TAR" -C / lib64 usr/lib usr/lib64 2>/dev/null || true

    # 将头文件等解压到系统根目录，无法恢复
    tar -xf tmp_test/allinfo.tar -C /

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd tmp_test || exit 1
    CHECK_RESULT $? 0 0 "no tmp_test uploaded, all test not run"

    mkdir -p run_tmp
    chmod 777 run_tmp

    pushd ltp_run || exit 1
    CHECK_RESULT $? 0 0 "no ltp_run uploaded, all test not run"
    ./runltp -p -q  -l "${CUR_DIR}"/tmp_test/run_log \
                    -o "${CUR_DIR}"/tmp_test/run_output \
                    -C "${CUR_DIR}"/tmp_test/run_fail \
                    -d "${TOP_DIR}"/run_tmp \
                    -S "${CUR_DIR}"/skiptest

    # 重新跑一下失败的用例
    rm -rf "${TOP_DIR}"/run_tmp/*
    ./runltp -p -q  -f "${CUR_DIR}"/tmp_test/run_fail \
                    -l "${CUR_DIR}"/tmp_test/run_log_1 \
                    -o "${CUR_DIR}"/tmp_test/run_output_1 \
                    -d "${TOP_DIR}"/run_tmp \
                    -C "${CUR_DIR}"/tmp_test/run_fail_1              
    popd || exit 1

    while read -r line || [[ -n $line ]]; do
        if grep -qxF "$line" "${CUR_DIR}"/ignore.out; then
            LOG_WARN "skip ltp testcase in ignore list: $line"
            continue
        fi
        LOG_ERROR "run ltp testcase fail case name: $line"
        tag=${line%% *}
        grep -nF -m 1 "$tag" "${CUR_DIR}"/tmp_test/run_output_1 || LOG_WARN "no detailed output found for tag: $tag"
        CHECK_RESULT 1 0 0 "run ltp testcase fail case name: $line"
    done < "${CUR_DIR}"/tmp_test/run_fail_1

    # 打印二次执行的所有用例的执行结果
    echo "====== cat ${CUR_DIR}/tmp_test/run_log_1 start ======"
    cat -n "${CUR_DIR}"/tmp_test/run_log_1
    echo "====== cat ${CUR_DIR}/tmp_test/run_log_1 end ======"
    # 打印二次执行仍失败的用例名单
    echo "====== cat ${CUR_DIR}/tmp_test/run_fail_1 start ======"
    cat -n "${CUR_DIR}"/tmp_test/run_fail_1
    echo "====== cat ${CUR_DIR}/tmp_test/run_fail_1 end ======"
    # 打印二次执行所有用例的详细日志
    echo "====== cat ${CUR_DIR}/tmp_test/run_output_1 start ======"
    cat -n "${CUR_DIR}"/tmp_test/run_output_1
    echo "====== cat ${CUR_DIR}/tmp_test/run_output_1 end ======"

    popd || exit 1

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    date -s "$CUR_DATE"

    # 还原被 sysroot 覆盖的系统库目录，避免 ABI 不匹配导致系统服务崩溃
    BACKUP_TAR=/root/.ltp_sysroot_backup.tar
    if [ -f "$BACKUP_TAR" ]; then
        tar -xf "$BACKUP_TAR" -C /
        ldconfig
        rm -f "$BACKUP_TAR"
    fi

    rm -rf "${TOP_DIR}"/run_tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
