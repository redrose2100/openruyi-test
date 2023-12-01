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
# @Desc      :   Test fluentd
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    useradd demo
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluentd -c ./data/fluent.conf -d pid.file
    SLEEP_WAIT 2
    pidnum=$(cat pid.file)
    ps -ef | grep ${pidnum} | grep "fluentd -c"
    CHECK_RESULT $? 0 0 "Check fluentd -d failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.file
    fluentd -c ./data/fluent.conf --daemon pid.file
    SLEEP_WAIT 2
    pidnum=$(cat pid.file)
    ps -ef | grep ${pidnum} | grep "fluentd -c"
    CHECK_RESULT $? 0 0 "Check fluentd --daemon failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.file
    fluentd -c ./data/fluent.conf --no-supervisor > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep "starting fluentd worker pid" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd --no-supervisor failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/fluent.conf --workers 2 > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker=1" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd --workers failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/fluent.conf --user demo &
    SLEEP_WAIT 2
    ps -u demo | grep "fluentd"
    CHECK_RESULT $? 0 0 "Check fluentd --user failed"
    kill -9 $(pgrep -f "fluentd -c")
    fluentd -c ./data/fluent.conf --group demo &
    SLEEP_WAIT 2
    ps -g demo | grep "fluentd"
    CHECK_RESULT $? 0 0 "Check fluentd --user failed"
    kill -9 $(pgrep -f "fluentd -c")
    fluentd -c ./data/fluent.conf  -o log.file &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker" log.file
    CHECK_RESULT $? 0 0 "Check fluentd -o failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/fluent.conf  --log log.file &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --log failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/fluent.conf  --log-rotate-size 10 -o log.file &
    SLEEP_WAIT 5
    kill -9 $(pgrep -f "fluentd -c")
    lognum=$(ls log.file* | wc -l)
    test ${lognum} -gt 1
    CHECK_RESULT $? 0 0 "Check fluentd --log-rotate-size failed"
    rm -f log.file*
    fluentd -c ./data/fluent.conf  --log-rotate-age 5 -o log.file &
    SLEEP_WAIT 5
    grep '"--log-rotate-age", "5"' log.file
    CHECK_RESULT $? 0 0 "Check fluentd --log-rotate-age failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/fluent.conf  --log-event-verbose -o log.file &
    SLEEP_WAIT 5
    grep -e "--log-event-verbose" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --log-event-verbose failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    userdel -r demo
    LOG_INFO "End to restore the test environment."
}
main "$@"
