#!/usr/bin/bash

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
# @Desc      :   kmesh.service start test
# ##################################
# shellcheck disable=SC1091
source ../libs/common.sh

function pre_test() {
    if ! dnf list Kmesh 2>/dev/null; then
        LOG_ERROR "未找到 Kmesh 软件包，退出码 255"
	exit 255
    fi
    DNF_INSTALL Kmesh 
}

function run_test() {
    LOG_INFO "Start testing..."
    
    # service start and stop
    systemctl start kmesh.service
    systemctl status kmesh.service > tmp_service.log
    grep 'active (running)' tmp_service.log
    CHECK_RESULT $? 0 0 "start kmesh service error"
    systemctl stop kmesh.service

    # --enable-mda
    sed -i "s/enable-kmesh/enable-mda -enable-ads=false/g" /usr/lib/systemd/system/kmesh.service
    systemctl daemon-reload
    systemctl start kmesh.service
    systemctl status kmesh.service > tmp_service.log
    grep 'active (running)' tmp_service.log
    CHECK_RESULT $? 0 0 "start kmesh service error"
    sleep 2
    mdacore disable
    bpftool prog show | grep -E "ma_ops|ma_redirect"
    CHECK_RESULT $? 0 1 "disable fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    cleanup
}

main "@"
