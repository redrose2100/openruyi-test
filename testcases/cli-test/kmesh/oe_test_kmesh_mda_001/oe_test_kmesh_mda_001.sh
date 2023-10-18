#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   oncn-mda test
# ##################################

source ../libs/common.sh

function pre_test() {
    DNF_INSTALL Kmesh
    wget -P ../pkg https://gitee.com/openeuler/Kmesh/blob/master/test/testcases/kmesh/pkg/fortio-1.38.1-1.$(arch).rpm
    yum localinstall -y ../pkg/fortio-*"$(arch)".rpm
}

function run_test() {
    LOG_INFO "Start testing..."

    # -enable-mda service
    sed -i "s/enable-kmesh/enable-mda -enable-ads=false/g" /usr/lib/systemd/system/kmesh.service
    systemctl daemon-reload
    systemctl start kmesh.service
    sleep 2
    check_mda_enable
    CHECK_RESULT $? 0 0 "enable mda error"

    start_fortio_server -http-port 127.0.0.1:11466
    fortio load -qps 0 -c 15 -t 30s http://127.0.0.1:11466 &> tmp_fortio_client.log &
    
    # check process accelerate
    sleep 2
    check_accelerate
    CHECK_RESULT $? 0 0 "accelerate error"
    
    systemctl stop kmesh.service
    mdacore query
    CHECK_RESULT $? 0 1 "accelerate error"

    LOG_INFO "Finish test!"
}

function post_test() {
    cleanup
}

main "@"

