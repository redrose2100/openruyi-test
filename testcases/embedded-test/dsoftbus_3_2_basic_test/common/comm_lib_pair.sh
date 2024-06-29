#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   seven
#@Contact       :   2461603862@qq.com
#@Date          :   2023-09-25
#@License       :   Mulan PSL v2
# @Desc    :
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_dsoftbus() {
    dsoftbus_client="$1"
    chmod 777 "$dsoftbus_client"
    SSH_SCP "$dsoftbus_client" root@"${NODE2_IPV4}":/ "${NODE2_PASSWORD}"

    echo 123456 > /etc/SN
    SSH_CMD "echo 456789 > /etc/SN"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}" "${NODE2_USER}"  300 22

    nohup /system/bin/start_services.sh softbus >/log.file 2>&1 &
    SSH_CMD "nohup /system/bin/start_services.sh softbus > /log.file 2>&1 &"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    sleep 5
}

function expect_test() {
    expect -v && echo "$?"
    sleep 5
}

function clean_dsoftbus() {
    dsoftbus_client="$1"
 
    /system/bin/stop_services.sh all
    SSH_CMD "pgrep -f $dsoftbus_client | xargs kill -15"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
    SSH_CMD "/system/bin/stop_services.sh all"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22

    rm -rf /log.file /data/data/* /etc/SN /storage/ /data/service/
    SSH_CMD "rm -rf /$dsoftbus_client /log.file /data/data/* /etc/SN"  "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22
}