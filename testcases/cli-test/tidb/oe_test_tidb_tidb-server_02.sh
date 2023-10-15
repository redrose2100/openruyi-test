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
    tidb-server -metrics-interval=2 -log-file ./tmp/test_mi.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"metrics-interval\\":2' ./tmp/test_mi.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -metrics-interval"
    tidb-server -path ./tmp/test_p1.log -log-file ./tmp/test_p2.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"path\\":\\"./tmp/test_p1.log\\"' ./tmp/test_p2.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -path"
    tidb-server -plugin-dir ./common -log-file ./tmp/test_pd2.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"plugin\\":{\\"dir\\":\\"./common\\"' ./tmp/test_pd2.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -plugin-dir"
    tidb-server -proxy-protocol-header-timeout 6 -log-file ./tmp/test_ppht.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"header-timeout\\":6' ./tmp/test_ppht.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -proxy-protocol-header-timeout"
    tidb-server -proxy-protocol-networks 127.0.0.1 -log-file ./tmp/test_ppn.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"networks\\":\\"127.0.0.1\\"' ./tmp/test_ppn.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -proxy-protocol-networks"
    tidb-server -repair-mode=true -log-file ./tmp/test_rm.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"repair-mode\\":true' ./tmp/test_rm.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -repair-mode"
    tidb-server -report-status=false -log-file ./tmp/test_rs.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"report-status\\":false' ./tmp/test_rs.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -report-status"
    tidb-server -require-secure-transport 2>&1 | grep '\\"require-secure-transport\\":true'
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -require-secure-transport"
    tidb-server -config ./common/config.toml -run-ddl=true -log-file ./tmp/test_rd.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"run-ddl\\":true' ./tmp/test_rd.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -run-ddl"
    tidb-server -socket /tmp/tidb.sock -log-file ./tmp/test_so.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"socket\\":\\"/tmp/tidb.sock\\"' ./tmp/test_so.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -socket"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"