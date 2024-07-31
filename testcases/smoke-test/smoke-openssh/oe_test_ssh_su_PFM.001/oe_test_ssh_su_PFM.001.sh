#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/07/27
# @License   :   Mulan PSL v2
# @Desc      :   ssh和su登录耗时小于10秒
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

test_dir=$(pwd)
set +e
total_num=500

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    rm -rf /root/.ssh/
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -N "" -q
    cp -arf /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
}

function run_test() {
    LOG_INFO "Start to run test."
    ssh -o "StrictHostKeyChecking no" root@127.0.0.1 "chmod 600 /root/.ssh/authorized_keys > /dev/null"
    CHECK_RESULT $? 0 0
    for ((i = 0; i < ${total_num}; i++)); do
        (time ssh -o "StrictHostKeyChecking no" root@127.0.0.1 "echo OK > /dev/null") >> "$test_dir"/time_log 2>&1
        CHECK_RESULT $? 0 0
    done
    cat "$test_dir"/time_log | grep real | cut -d'm' -f2 | cut -d'.' -f1 > "$test_dir"/time_log_new
    count=0
    for i in $(cat "$test_dir"/time_log_new); do
        if [[ $i -gt 10 ]]; then
            ((count++))
            echo "ssh time is larger than 10s:$count"
        fi
    done
    [ $count -le $((total_num / 10)) ]
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /root/.ssh/
    [ "${ets_expects_failed}" = "0" ] && rm -rf "$test_dir"/time_log
}

main "$@"

