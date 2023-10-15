# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   shao yuteng
# @Contact   	:   yuteng@isrc.iscas.ac.cn
# @Date      	:   2022-10-3
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of tidb package
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tidb
    test -d tmp || mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tidb-server -status 11111 -log-file ./tmp/test_sta.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"status-port\\":11111' ./tmp/test_sta.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -status"
    tidb-server -status-host 127.0.0.1 -log-file ./tmp/test_sh.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"status-host\\":\\"127.0.0.1\\"' ./tmp/test_sh.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -status-host"
    tidb-server -store=tikv -log-file ./tmp/test_sto.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"store\\":\\"tikv\\"' ./tmp/test_sto.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -store"
    tidb-server -token-limit=1001 -log-file ./tmp/test_tl.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"token-limit\\":1001' ./tmp/test_tl.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -token-limit"
    tidb-server -plugin-dir ./common -plugin-load conn_ip_example-1 -log-file ./tmp/test_pl.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"load\\":\\"conn_ip_example-1\\"' ./tmp/test_pl.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -plugin-load"
    tidb-server -enable-binlog=true -log-file ./tmp/test_eb.log &
    SLEEP_WAIT 1 
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"binlog\\":{\\"enable\\":true' ./tmp/test_eb.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -enable-binlog"
    tidb-server -repair-mode=true -repair-list ["db.table1","db.table2"] -log-file ./tmp/test_rl.log & 
    SLEEP_WAIT 1 
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}') 
    cat ./tmp/test_rl.log | grep '\\"repair-table-list\\":' | grep '\\"db.table1\\",\\"db.table2\\"' 
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -repair-list" 
    tidb-server -lease 45 -log-file ./tmp/test_le.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"lease\\":\\"45\\"' ./tmp/test_le.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -lease"
    tidb-server -log-slow-query ./tmp/test_lsq1.log -log-file ./tmp/test_lsq2.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"slow-query-file\\":\\"./tmp/test_lsq1.log\\"' ./tmp/test_lsq2.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -log-slow-query"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"