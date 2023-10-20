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
#@Author        :   wangtingting
#@Contact       :   wangting199611@126.com
#@Date          :   2023/10/12
#@License       :   Mulan PSL v2
#@Desc          :   kmesh test public functions
####################################
# shellcheck disable=SC2068,SC2126,SC2119,SC2010,SC2002
source "${OET_PATH}"/libs/locallibs/common_lib.sh

#load ebpf
progs="ma_ops ma_redirect"
maps="sock_ops_map sock_helper_map sock_param_map sock_proxy_map sock_dump_map sock_ddata_map"
pin_files="sock_dump_data_map sock_dump_map sock_helper_map sock_ops_ip4 sock_ops_map sock_param_map sock_proxy_map sock_redirect"
pin_path="/sys/fs/bpf/meshAccelerate"

# environment preparation
function env_init()
{
    DNF_INSTALL Kmesh
    mkdir /mnt/kmesh_cgroup2
    mount -t cgroup2 none /mnt/kmesh_cgroup2/

    wget -P ../pkg https://gitee.com/openeuler/Kmesh/blob/master/test/testcases/kmesh/pkg/fortio-1.38.1-1."$(arch)".rpm
    yum localinstall -y ../pkg/fortio-*"$(arch)".rpm
    insmod /lib/modules/kmesh/kmesh.ko
    lsmod | grep kmesh
    CHECK_RESULT $? 0 0 "insmod kmesh.ko failed"
}

# start kmesh-daemon
function start_kmesh()
{
    kmesh-daemon -enable-kmesh=true -enable-ads=false -config-file "$(pwd)"/conf/test_conf.json > tmp_kmesh_daemon.log &
    sleep 3
    
    cat tmp_kmesh_daemon.log | grep "command StartServer successful"
    CHECK_RESULT $? 0 0 "kmesh-daemon start failed"
}

# start fortio server
# default localhost:8080
# if you want to change ip or port, must input all, follows ip:port 
# cmd is same as the fortio server function
function start_fortio_server()
{
    fortio server $@ > tmp_fortio_server.log 2>&1 &
    sleep 0.2
    echo "$@" > tmp_fortio_cmd.log
    ip_port=$(grep -oE "[0-9]+.[0-9]+.[0-9]+.[0-9]+:[0-9]+" tmp_fortio_cmd.log) || ip_port="127.0.0.1:8080"
    cat tmp_fortio_server.log | grep "http://${ip_port}/fortio/"
    CHECK_RESULT $? 0 0 "fortio server start failed"
}

# load kmesh config and check
function load_kmesh_config()
{
    kmesh-cmd -config-file="$(pwd)"/conf/test_conf.json > tmp_kmesh_cmd.log &
    CHECK_RESULT $? 0 0 "kmesh-cmd start failed"
    sleep 2
    
    curl http://127.0.0.1:15200/bpf/kmesh/maps --connect-timeout 5 > tmp_kmesh_conf_read.log
    cat tmp_kmesh_conf_read.log | grep "stenerConfigs\|routeConfigs\|clusterConfigs"
    CHECK_RESULT $? 0 0 "check kmesh conf failed"
}

# use bpftool trace test result
function curl_test()
{
    bpftool prog tracelog > tmp_bpftool_prog_trace.log &
    
    curl -g http://127.0.0.1:23333/fortio/ --connect-timeout 5 > /dev/null
    CHECK_RESULT $? 0 0 "curl fortio server failed"
    pkill bpftool
    
    err_num=$(cat tmp_bpftool_prog_trace.log | grep " ERR: " | wc -l)
    CHECK_RESULT "$err_num" 0 0 "check kmesh-daemon log failed"

    # check fortio server log
    cat tmp_fortio_server.log | grep "GET /fortio/"
    CHECK_RESULT $? 0 0 "check fortio server log failed"
}

# environment cleanup
# end the fortio and kmesh-daemon process
# remove fortio Kmesh
function cleanup()
{    
    pkill fortio
    pkill kmesh-daemon
    sleep 2
    rmmod kmesh
    umount /mnt/kmesh_cgroup2
    rm -rf /mnt/kmesh_cgroup2
    yum remove -y fortio
    DNF_REMOVE
    rm -rf tmp*.log
}

# check enable mda
function check_mda_enable() {
    mdacore query || return 1
    check_load_ebpf || return 3
    return 0
}

# check mda map
function check_load_ebpf() {
    for prog in $progs; do
        bpftool prog show | grep "$prog" || return 1
    done

    for map in $maps; do
        bpftool map show | grep "$map" || return 2
    done

    for pin in $pin_files; do
        ls $pin_path | grep "$pin" || return 3
    done
    return 0
}

# check process accelerate
function check_accelerate() {
    local tmp_res=0

    proxy_id=$(bpftool map show | grep sock_proxy_map | awk -F ':' '{print $1}')
    bpftool map dump id "$proxy_id" | grep key
    CHECK_RESULT $? 0 0 "accelerate failed." || {
        bpftool map dump id "$proxy_id"
        tmp_res=1
    }

    return $tmp_res
}

