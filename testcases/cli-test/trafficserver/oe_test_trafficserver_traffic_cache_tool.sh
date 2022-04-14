#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com 
# @Date      :   2022/03/25
# @License   :   Mulan PSL v2
# @Desc      :   Test traffic_ctl
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO  "trafficserver has been installed"
    pkill traffic_m
    pkill [TS_MAIN]
    pkill traffic_s
    rm -rf /usr/local/var/trafficserver/*.lock
    mkdir -p /usr/local/etc/trafficserver/
    touch /usr/local/etc/trafficserver/storage.config
    touch /usr/local/etc/trafficserver/volume.config
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    #Print usage information
    traffic_cache_tool -h |grep "Commands"
    CHECK_RESULT $? 0 0 "failed to print usage infomation"
    #Allocate unused storage space
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config alloc free
    CHECK_RESULT $? 0 0 "failed to allocate unused storage space" 
    #clear an specific span
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config clear span
    CHECK_RESULT $? 0 0 "failed to clear an specific span" 
    #clear specific span
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config clearspan span
    CHECK_RESULT $? 0 0 "failed to clear specific span" 
    #walk bucket chains for loops
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config dir_check bucket_chain
    CHECK_RESULT $? 0 0 "failed to walk bucket chains for loops" 
    #check the freelist for loop
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config dir_check freelist
    CHECK_RESULT $? 0 0 "failed to check the freelist for loop" 
    #Full report of the cache storage
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config dir_check full |grep "succeeded"
    CHECK_RESULT $? 0 0 "failed to check the freelist for loop" 
    #List the stripes
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config list stripes
    CHECK_RESULT $? 0 0 "failed to list the stripes" 
    #Scans the whole cache and lists the urls of the cached contents
    traffic_cache_tool --spans=/usr/local/etc/trafficserver/storage.config --volumes=/usr/local/etc/trafficserver/volume.config scan
    CHECK_RESULT $? 0 0 "failed to scan the whole cache" 
    #Clear all spans
    traffic_cache_tool  --spans=/usr/local/etc/trafficserver/storage.config  --volumes=/usr/local/etc/trafficserver/volume.config  --write clear |grep "Writing"
    CHECK_RESULT $? 0 0 "failed to clear all spans" 
    #Clear a single span
    traffic_cache_tool  --spans=/usr/local/etc/trafficserver/storage.config  --volumes=/usr/local/etc/trafficserver/volume.config clear span --device "/dev/" --write |grep "Writing"
    CHECK_RESULT $? 0 0 "failed to clear a single span" 
    #Initialize a new span
    traffic_cache_tool  --spans=/usr/local/etc/trafficserver/storage.config  --volumes=/usr/local/etc/trafficserver/volume.config init --input "/dev/sda3" --write |grep "Writing"
    CHECK_RESULT $? 0 0 "failed to initialize a new span" 
    #Find Stripe Assignment
    traffic_cache_tool  --spans=/usr/local/etc/trafficserver/storage.config  --volumes=/usr/local/etc/trafficserver/volume.config init --write --input "urls.txt" |grep "Writing"
    CHECK_RESULT $? 0 0 "failed to find stripe assignment" 
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill traffic_m
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm  -rf /usr/local/var/trafficserver/manager.lock
    LOG_INFO "End to restore the test environment."
}

main "$@"
