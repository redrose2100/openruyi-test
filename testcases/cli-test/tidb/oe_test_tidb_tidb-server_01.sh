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
    tidb-server -log-file ./tmp/test_lo.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    test -f ./tmp/test_lo.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -log-file"
    tidb-server -L info -log-file ./tmp/test_L.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep "INFO" ./tmp/test_L.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -L"
    tidb-server -P 4000 -log-file ./tmp/test_P.log &
    SLEEP_WAIT 1 
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"port\\":4000' ./tmp/test_P.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -P"
    tidb-server -V 2>&1 | grep "Release Version: v[[:digit:]]*"
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -V"
    tidb-server -advertise-address 127.0.0.1 -log-file ./tmp/test_aa.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"advertise-address\\":\\"127.0.0.1\\"' ./tmp/test_aa.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -advertise-address"
    tidb-server -config ./common/config.toml -log-file ./tmp/test_c.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"split-table\\":false' ./tmp/test_c.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -config"
    tidb-server -config ./common/config.toml -config-check=true 2>&1 | grep "config check successful"
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -config-check"
    tidb-server -cors 127.0.0.1 -log-file ./tmp/test_cors.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"cors\\":\\"127.0.0.1\\"' ./tmp/test_cors.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -cors"
    tidb-server -host 127.0.0.1 -log-file ./tmp/test_host.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"host\\":\\"127.0.0.1\\",\\"advertise-address\\":\\"127.0.0.1\\"' ./tmp/test_host.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -host"
    tidb-server -metrics-addr=127.0.0.1:9091 -log-file ./tmp/test_ma.log &
    SLEEP_WAIT 1
    kill -9 $(ps -aux | grep "tidb-server " | awk 'NR==1{print $2}')
    grep '\\"metrics-addr\\":\\"127.0.0.1:9091\\"' ./tmp/test_ma.log
    CHECK_RESULT $? 0 0 "Failed to run tidb-server -metrics-addr"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"