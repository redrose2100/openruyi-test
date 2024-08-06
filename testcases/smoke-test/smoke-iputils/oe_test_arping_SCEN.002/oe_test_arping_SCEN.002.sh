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
# @Date      :   2024/06/13
# @License   :   Mulan PSL v2
# @Desc      :   arping内存泄漏检查
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    eth_main=$(ip a | grep "$OET_LOCAL_IP" | awk '{print $NF}')
}

function run_test() {
    LOG_INFO "Start to run test."
    arping -I "$eth_main" "$OET_REMOTE_IP" > arping.log 2>&1 &
    pid=$!

    wait_cmd_ok "ps -aux | grep -v grep | grep -w 'arping -I $eth_main $OET_REMOTE_IP'" 1 10

    rss_value=$(ps -aux | grep -w "arping -I $eth_main $OET_REMOTE_IP" | grep -v grep | awk '{print $6}') #执行30min,若rss增加10%，便认定为有内存泄漏
    for ((i = 0; i < 60; i++)); do
        sleep 5
        ps -aux | grep -w arping | grep -v grep
        rss_value_now=$(ps -aux | grep -w "arping -I $eth_main $OET_REMOTE_IP" | grep -v grep | awk '{print $6}')
        [ $((rss_value_now * 10)) -le $((rss_value * 11)) ]
        CHECK_RESULT $? 0 0
    done
    LOG_INFO "End to run test."
}

function post_test() {
    kill -9 $pid
    rm -fr arping.log
}
main "$@"
~
~
