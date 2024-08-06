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
# @Date      :   2024/06/12
# @License   :   Mulan PSL v2
# @Desc      :   指定ping退出之前的超时（以秒为单位），无论已发送或接收了多少数据包 -w参数
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    yum -y install iputils ping6
    eth_main=$(get_eth_main local)
}

function run_test() {
    LOG_INFO "Start to run test."
    (time ping6 "$REMOTE_IPV6"%"${eth_main}" -w 3) > log 2>&1
    time=$(cat log | grep real | awk '{print $2}' | awk -F'm' '{print $2}' | awk -F'.' '{print $1}')
    if [ "$time" -gt 4 ]; then
        CHECK_RESULT $? 0 0
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove iputils ping6
}

main "$@"
~
