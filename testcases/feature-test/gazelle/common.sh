#!/usr/bin/bash

#opyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangju1
# @Contact   :   zhangju@iscas.ac.cn
# @Date      :   2026-04-14
# @License   :   Mulan PSL v2
# @Desc      :   Net Public function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function get_free_eth() {
    local num_eth=$1
    echo "${NODE1_NIC[@]}"
    NODE1_NIC=$(python3 "${OET_PATH}/libs/locallibs/get_test_device.py" --node 1 --device nic)
    LOCAL_ETH=(${NODE1_NIC[@]/$(ip route | grep "${NODE1_IPV4}" | awk '{print$3}')/})
    [ "${#LOCAL_ETH[@]}" -ge "${num_eth}" ] || exit 1
}
