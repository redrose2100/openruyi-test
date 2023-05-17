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
# @Desc      :   Test trafgen
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
    trafgen -p --dev lo --conf ./data/synflood.trafgen --gap 1000 -n 10 | grep "on CPU0"
    CHECK_RESULT $? 0 0 "Check trafgen --gap failed"
    trafgen -p --dev lo --conf ./data/synflood.trafgen -t 1000 -n 10 | grep "on CPU0"
    CHECK_RESULT $? 0 0 "Check trafgen -t failed"
    trafgen -p --dev lo --conf ./data/synflood.trafgen -b 1kB -n 2 | grep "usec on CPU0"
    CHECK_RESULT $? 0 0 "Check trafgen -b failed"
    trafgen -p --dev lo --conf ./data/synflood.trafgen --rate 1kB -n 2 | grep "usec on CPU0"
    CHECK_RESULT $? 0 0 "Check trafgen --rate failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen -E 2 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -E failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen --seed 2 -n 2 | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --seed failed"
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -u `id -u bob` -g `id -g bob` -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -u failed"
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' --user `id -u bob` -g `id -g bob` -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -user failed"
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -u `id -u bob` -g `id -g bob` -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -g failed"
    trafgen --dev lo '{ fill(0xff, 6), 0x00, 0x02, 0xb3, rnd(3), c16(0x0800), fill(0xca, 64) }' -u `id -u bob` --group `id -g bob` -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --group failed"
    trafgen --dev lo '{ rnd(64), 0b11001100, 0xaa }' --prio-high -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --prio-high failed"
    trafgen --dev lo '{ rnd(64), 0b11001100, 0xaa }' -H -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen -H failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen --no-sock-mem -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --no-sock-mem failed"
    trafgen -p --dev lo --conf ./data/synflood.trafgen --qdisc-path -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --qdisc-path failed"
    trafgen -p --dev lo --conf ./data/synflood.trafgen -q -n 2 | grep "packets to schedule"
    CHECK_RESULT $? 0 0 "Check trafgen --qdisc-path failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen -n 2 --verbose | grep "Enabled kernel qdisc bypass"
    CHECK_RESULT $? 0 0 "Check trafgen --verbose failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen -n 2 -V | grep "Enabled kernel qdisc bypass"
    CHECK_RESULT $? 0 0 "Check trafgen -V failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen -n 2 --no-cpu-stats | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen --no-cpu-stats failed"
    trafgen --cpp --dev lo --conf ./data/udp_example01.trafgen -n 2 -C | grep "packets outgoing"
    CHECK_RESULT $? 0 0 "Check trafgen -C failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
