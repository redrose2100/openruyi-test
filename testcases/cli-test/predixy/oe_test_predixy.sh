#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test predixy
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "predixy tar"
    tar -xvf ./common/data.tar.gz
    redis-server ./redis/26379.conf --sentinel &
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    predixy -h 2>&1 | grep "predixy -h or --help"
    CHECK_RESULT $? 0 0 "Check predixy -h failed"
    predixy --help 2>&1 | grep "predixy -h or --help"
    CHECK_RESULT $? 0 0 "Check predixy --help failed"
    predixy -v 2>&1 | grep "predixy predixy-$(rpm -qa predixy |awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "Check predixy -v failed"
    predixy --version 2>&1 | grep "predixy predixy-$(rpm -qa predixy |awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "Check predixy --version failed"
    predixy ./data/predixy.conf --Name=demo > tmp.txt &
    sleep 5
    grep "predixy running with Name:demo" tmp.txt
    CHECK_RESULT $? 0 0 "Check predixy --Name failed"
    kill -9 $(ps -aux | grep "predixy ./data" |  grep -v "grep" | awk -F " " '{print $2}')
    rm -f tmp.txt 
    predixy ./data/predixy.conf --Bind=127.0.0.1:7617 > tmp.txt &
    sleep 3
    grep "Proxy.cpp:112 predixy listen in 127.0.0.1:7617" tmp.txt
    CHECK_RESULT $? 0 0 "Check predixy --Bind failed"
    kill -9 $(ps -aux | grep "predixy ./data" |  grep -v "grep" | awk -F " " '{print $2}')
    rm -f tmp.txt
    predixy ./data/predixy.conf --WorkerThreads=2 > tmp.txt &
    sleep 3
    grep "predixy running with Name:PredixyExample Workers:2" tmp.txt
    CHECK_RESULT $? 0 0 "Check predixy --WorkerThreads failed"
    kill -9 $(ps -aux | grep "predixy ./data" |  grep -v "grep" | awk -F " " '{print $2}')
    rm -f tmp.txt
    predixy ./data/predixy.conf --localDC=bj > tmp.txt &
    sleep 3
    grep "N Proxy.cpp:112 predixy listen in 127.0.0.1:7617" tmp.txt
    CHECK_RESULT $? 0 0 "Check predixy --localDC failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf data/ redis/ tmp.txt
    kill -9 $(ps -aux | grep "predixy ./data" |  grep -v "grep" | awk -F " " '{print $2}')
    kill -9 $(ps -aux | grep "redis" | awk 'NR==1{print $2}')
    LOG_INFO "End to restore the test environment."
}
main "$@"
