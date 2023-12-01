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
# @Desc      :   Test netsniff-ng
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    netsniff-ng --help | grep "Usage: netsniff-ng"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --help failed"
    netsniff-ng -h | grep "Usage: netsniff-ng"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -h failed"
    netsniff-ng -v | grep "netsniff-ng 0.6.8"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -v failed"
    netsniff-ng --version | grep "netsniff-ng 0.6.8"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --version failed"
    netsniff-ng -i ${NODE1_NIC} --out dump.cfg -s -n 2
    test -f dump.cfg
    CHECK_RESULT $? 0 0 "Check netsniff-ng -i failed"
    rm -f dump.cfg
    netsniff-ng -d ${NODE1_NIC} --out dump.cfg -s -n 2
    test -f dump.cfg
    CHECK_RESULT $? 0 0 "Check netsniff-ng -d failed"
    rm -f dump.cfg
    netsniff-ng --dev ${NODE1_NIC} --out dump.cfg -s -n 2
    test -f dump.cfg
    CHECK_RESULT $? 0 0 "Check netsniff-ng --dev failed"
    rm -f dump.cfg
    netsniff-ng --in ${NODE1_NIC} --out dump.cfg -s -n 2 | grep "2  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --in failed"
    rm -f dump.cfg
    netsniff-ng --dev ${NODE1_NIC} --out dump.cfg -s -n 2
    test -f dump.cfg
    CHECK_RESULT $? 0 0 "Check netsniff-ng --out failed"
    rm -f dump.cfg
    netsniff-ng --dev ${NODE1_NIC} -o dump.cfg -s -n 2
    test -f dump.cfg
    CHECK_RESULT $? 0 0 "Check netsniff-ng -o failed"
    rm -f dump.cfg
    netsniff-ng --fanout-group 1 -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --fanout-group failed"
    rm -f dump.cfg
    netsniff-ng -C 1 -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -C failed"
    rm -rf dump.cfg
    netsniff-ng --fanout-type cpu -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --fanout-type failed"
    rm -f dump.cfg
    netsniff-ng -K cpu -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -K failed"
    rm -f dump.cfg
    netsniff-ng --fanout-opts defrag -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --fanout-opts failed"
    rm -f dump.cfg
    netsniff-ng -L defrag -s --in ${NODE1_NIC} --out dump.cfg -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -L failed"
    rm -f dump.cfg
    bpfc ./data/faa > tmp.bpf
    netsniff-ng -f tmp.bpf -s --in ${NODE1_NIC} --out dump.cfg -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -f failed"
    rm -f tmp.bpf dump.cfg
    bpfc ./data/faa > tmp.bpf
    netsniff-ng --filter tmp.bpf -s --in ${NODE1_NIC} --out dump.cfg -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --filter failed"
    rm -f tmp.bpf dump.cfg
    netsniff-ng --type host -s --in ${NODE1_NIC} --out dump.cfg -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --type failed"
    rm -f dump.cfg
    netsniff-ng -t host -s --in ${NODE1_NIC} --out dump.cfg -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -t failed"
    rm -f dump.cfg
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
