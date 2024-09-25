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
    chmod 777 "$1"

    echo 123456 > /etc/SN
    
    /system/bin/start_services.sh softbus >/log.file 2>&1 &
}

function expect_test() {
    expect -v && echo "$?"
    sleep 5
}

function clean_dsoftbus() {
    /system/bin/stop_services.sh all
    rm -rf /log.file /data /etc/SN /storage/ /data/service/
}
