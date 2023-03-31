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
    netsniff-ng --in ${NODE1_NIC} -T 0xa1e2cb12 -D -n 1 | grep "netsniff-ng pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -D failed"
    netsniff-ng --in ${NODE1_NIC} -T 0xa1e2cb12 --dump-pcap-types -n 1 | grep "netsniff-ng pcap"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --dump-pcap-types failed"
    bpfc ./data/faa > tmp.bpf
    netsniff-ng --in any --filter tmp.bpf -B -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -B failed"
    netsniff-ng --in any --filter tmp.bpf --dump-bpf -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --dump-bpf failed"
    rm -f tmp.bpf
    netsniff-ng --in any --out lo -r -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -r failed"
    netsniff-ng --in any --out lo --rand -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --rand failed"
    netsniff-ng --in any -M -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -M failed"
    netsniff-ng --in any --no-promisc -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --no-promisc failed"
    netsniff-ng --in any -A -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -A failed"
    netsniff-ng --in any --no-sock-mem -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --no-sock-mem failed"
    netsniff-ng --in any --no-hwtimestamp -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --no-hwtimestamp failed"
    netsniff-ng --in any -N -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -N failed"
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in dump.pcap --mmap | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --mmap failed"
    rm -f dump.pcap 
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in dump.pcap -m | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -m failed"
    rm -f dump.pcap 
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in dump.pcap -G | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -G failed"
    rm -f dump.pcap 
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in dump.pcap --sg | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --sg failed"
    rm -f dump.pcap 
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in any --out dump.pcap -c -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -c failed"
    rm -f dump.pcap
    netsniff-ng --in any --out dump.pcap --silent --bind-cpu 0 -n 2
    netsniff-ng --in any --out dump.pcap --clrw -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --clrw failed"
    rm -f dump.pcap
    netsniff-ng --in any --ring-size 1MiB -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --ring-size failed"
    netsniff-ng --in any -S 1MiB -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -S failed"
    netsniff-ng --in any -k1000 -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -k failed"
    netsniff-ng --in any --kernel-pull 1000 -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --kernel-pull failed"
    netsniff-ng --in any -J -n 1 | grep "1  packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -J failed"
    netsniff-ng --in any --jumbo-support -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -J failed"
    netsniff-ng --in any --out dump.cfg --silent --bind-cpu 0 -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --bind-cpu failed"
    netsniff-ng --in any --out dump.cfg --silent -b 0 -n 2 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -b failed"
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
