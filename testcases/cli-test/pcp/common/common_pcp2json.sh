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
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-10-23
#@License       :   Mulan PSL v2
#@Desc          :   Public class
#####################################
# shellcheck disable=SC1090,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function deploy_env {
    DNF_INSTALL "pcp pcp-export-pcp2json pcp-system-tools"
    pip install requests zstandard
    systemctl enable pmcd
    systemctl start pmcd
    systemctl enable pmlogger
    systemctl start pmlogger
    SLEEP_WAIT 10
    host_name=$(hostname)
    archive_data=$(pcp -h "$host_name" | grep 'primary logger:' | awk -F: '{print $NF}').0
    metric_name=disk.dev.write
}


function clean_env {
    pip uninstall -y requests zstandard
    systemctl disable pmcd
    systemctl stop pmcd
    systemctl disable pmlogger
    systemctl stop pmlogger
}
