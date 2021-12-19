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
#@Author        :   hejinjin
#@Contact       :   jinjin@isrc.iscas.ac.cn
#@Date          :   2021/12/19
#@License       :   Mulan PSL v2
#@Desc          :   netperf command line test public functions
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_env() {

    DNF_INSTALL "netperf"
    DNF_INSTALL "netperf" 2
    rdport=$(GET_FREE_PORT "$NODE2_IPV4")
    P_SSH_CMD --cmd "systemctl stop firewalld
             netserver -p ${rdport} >/dev/null 2>&1 &
    "
}

function clean_env() {

    P_SSH_CMD --cmd "kill -9 \$(ps -ef | grep netserver | grep -v grep | awk '{print \$2}')
             systemctl start firewalld
             "
    DNF_REMOVE

}
