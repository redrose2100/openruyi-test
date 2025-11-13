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
# @Desc      :   kmesh dark launch test
# ##################################
# shellcheck disable=SC1091
source ../libs/common.sh

function pre_test() {
    env_init
    KO_FILES=$(find /lib/modules /usr/lib/modules -name "*kmesh*.ko" 2>/dev/null)
    if [ -z "$KO_FILES" ]; then
            echo "未找到 Kmesh 相关 .ko 文件，退出码 255"
            exit 255
    fi
}

function run_test() {
    LOG_INFO "Start testing..."

    # start fortio server 11466 
    # start fortio server 11488
    start_fortio_server -http-port 127.0.0.1:11466 -echo-server-default-params="header=server:1"
    start_fortio_server -http-port 127.0.0.1:11488 -echo-server-default-params="header=server:2"

    # start kmesh-daemon
    start_kmesh

    # use kmesh-cmd load conf and check conf load ok
    load_kmesh_config
    
    # curl 100 times, Server: 1 and Server: 2 should be 8:2
    # the traffic is not completely regular,Server: 1 belong 70%-90% and Server: 2 belong 10%-30%
    for ((i=0;i<100;i++))
    do
        curl -v http://127.0.0.1:23333 >> tmp_trace.log 2>&1
    done
    
    a=$(grep -c 'Server: 1' tmp_trace.log)
    b=$(grep -c 'Server: 2' tmp_trace.log)
    if [ "$a" -gt 70 ] && [ "$a" -lt 90 ] && [ "$b" -lt 30 ] && [ "$b" -gt 10 ];then
        result=0
    else
        result=1
    fi
    CHECK_RESULT $result 0 0 "bad dark launch"

    LOG_INFO "Finish test!"
}

function post_test() {
    cleanup
}

main "$@"
