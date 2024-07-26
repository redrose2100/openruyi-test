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

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    EXECUTE_T="1440m"
    echo "EXECUTE_T = ${EXECUTE_T}"

    MAKEDIR=$(cd .. && pwd)
    chmod 777 "${MAKEDIR}"/make
    MAKE="${MAKEDIR}"/make
    echo "MAKE = ${MAKE}"

    timestap=$(stat -c %Y tmp_test/allinfo.tar)
    formart_date=$(date '+%Y-%m-%d %H:%M:%S' -d @"$timestap")
    date -s "$formart_date"

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
                    -d "${CUR_DIR}"/tmp_test/run_tmp \
                    -S "${CUR_DIR}"/skiptest

    # 不设定-d重新跑一下失败的用例
    umount /tmp
    ./runltp -p -q  -f "${CUR_DIR}"/tmp_test/run_fail \
                    -l "${CUR_DIR}"/tmp_test/run_log_1 \
                    -o "${CUR_DIR}"/tmp_test/run_output_1 \
                    -C "${CUR_DIR}"/tmp_test/run_fail_1              
    popd || exit 1

    while read -r line || [[ -n $line ]]; do
        if grep -q "$line" ignore.out; then
            continue
        fi
        CHECK_RESULT $? 0 0 "run posix testcase fail case name: $line"
    done < run_fail_1

    popd || exit 1

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    date -s "$CUR_DATE"

    LOG_INFO "End to restore the test environment."
}

main "$@"
