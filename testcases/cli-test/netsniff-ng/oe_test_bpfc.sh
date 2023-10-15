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
# @Desc      :   Test bpfc
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar cpp"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    bpfc --version | grep "a tiny BPF compiler"
    CHECK_RESULT $? 0 0 "Check bpfc --version failed"
    bpfc -v | grep "a tiny BPF compiler"
    CHECK_RESULT $? 0 0 "Check bpfc -v failed"
    bpfc -h | grep "Usage: bpfc"
    CHECK_RESULT $? 0 0 "Check bpfc -h failed"
    bpfc -h | grep "Usage: bpfc"
    CHECK_RESULT $? 0 0 "Check bpfc --help failed"
    bpfc -i ./data/faa  > foo
    grep "0x28" foo
    CHECK_RESULT $? 0 0 "Check bpfc -i failed"
    rm -f foo
    bpfc --input ./data/faa  > foo
    grep "0x28" foo
    CHECK_RESULT $? 0 0 "Check bpfc --input failed"
    rm -f foo
    bpfc -i ./data/foobar -p  > foo
    wc -l foo | grep 13
    CHECK_RESULT $? 0 0 "Check bpfc -p failed"
    rm -f foo
    bpfc -i ./data/foobar --cpp  > foo
    wc -l foo | grep 13
    CHECK_RESULT $? 0 0 "Check bpfc --cpp failed"
    rm -f foo
    bpfc -i ./data/foo -p -D type=2> foo
    grep "0x20" foo
    CHECK_RESULT $? 0 0 "Check bpfc -D failed"
    rm -f foo
    bpfc -i ./data/foo -p --define type=2> foo
    grep "0x20" foo
    CHECK_RESULT $? 0 0 "Check bpfc --define failed"
    rm -f foo
    bpfc -f tcpdump -i ./data/faa -p -D type=2 |wc -l | grep 6
    CHECK_RESULT $? 0 0 "Check bpfc -f failed"
    bpfc --format tcpdump -i ./data/faa -p -D type=2 |wc -l | grep 6
    CHECK_RESULT $? 0 0 "Check bpfc --format failed"
    bpfc -f xt_bpf -b -i ./data/foobar > tmp.txt
    grep "13,40 0 0 12,21 0 10 2048" tmp.txt
    CHECK_RESULT $? 0 0 "Check bpfc -b failed"
    rm -f tmp.txt
    bpfc -f xt_bpf --bypass -i ./data/foobar > tmp.txt
    grep "13,40 0 0 12,21 0 10 2048" tmp.txt
    CHECK_RESULT $? 0 0 "Check bpfc --bypass failed"
    rm -f tmp.txt
    bpfc --format tcpdump -i ./data/faa -p -D type=2 |wc -l | grep 6
    CHECK_RESULT $? 0 0 "Check bpfc -V failed"
    bpfc --format tcpdump -i ./data/faa -p -D type=2 |wc -l | grep 6
    CHECK_RESULT $? 0 0 "Check bpfc --verbose failed"
    bpfc -i ./data/foobar -d | wc -l | grep 26
    CHECK_RESULT $? 0 0 "Check bpfc -d failed"
    bpfc -i ./data/foobar --dump | wc -l | grep 26
    CHECK_RESULT $? 0 0 "Check bpfc --dump failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
