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
# @Desc      :   Test curvetun
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    DNF_INSTALL netsniff-ng 2
    tar -xvf ./common/data.tar.gz > /dev/null
    SSH_SCP ./common/curvetunInfo.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunInfo.sh ${NODE2_PASSWORD}
    SSH_SCP ./common/curvetunDepoly.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunDepoly.sh ${NODE2_PASSWORD}
    SSH_SCP ./common/curvetunClient.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunClient.sh ${NODE2_PASSWORD}
    SSH_CMD "bash -x /tmp/curvetunDepoly.sh" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "bash -x /tmp/curvetunInfo.sh" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunServer.info . ${NODE2_PASSWORD}
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test -d
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunserver\\r"
            }
        }
        expect eof
EOF
    curvetun curvetun -s -p 6666 -d curves0
    CHECK_RESULT $? 0 0 "Check curvetun -s failed"
    curvetun curvetun -s -p 6666 -dev curves0
    CHECK_RESULT $? 0 0 "Check curvetun --dev failed"
    curvetun -s --port 6666
    CHECK_RESULT $? 0 0 "Check curvetun --port failed"
    curvetun -s -p 6666
    CHECK_RESULT $? 0 0 "Check curvetun -p failed"
    curvetun --server -p 6666
    CHECK_RESULT $? 0 0 "Check curvetun --server failed"
    curvetun -s -p 6666
    CHECK_RESULT $? 0 0 "Check curvetun -s failed"
    curvetun -s -p 6666 -N
    CHECK_RESULT $? 0 0 "Check curvetun -N failed"
    curvetun -s -p 6666 --no-logging
    CHECK_RESULT $? 0 0 "Check curvetun --no-logging failed"
    curvetun -s -p 6666 -u
    CHECK_RESULT $? 0 0 "Check curvetun -u failed"
    curvetun -s -p 6666 --udp
    CHECK_RESULT $? 0 0 "Check curvetun --udp failed"
    curvetun -s -p 6666 -4
    CHECK_RESULT $? 0 0 "Check curvetun -4 failed"
    curvetun -s -p 6666 --ipv4
    CHECK_RESULT $? 0 0 "Check curvetun --ipv4 failed"
    curvetun -s -p 6666 -6
    CHECK_RESULT $? 0 0 "Check curvetun -6 failed"
    curvetun -s -p 6666 --ipv6
    CHECK_RESULT $? 0 0 "Check curvetun --ipv6 failed"
    curvetun --server -4 -u -N --port 6666 --stun stunserver.org
    CHECK_RESULT $? 0 0 "Check curvetun --stun failed"
    curvetun --server -4 -u -N --port 6666 -t stunserver.org
    CHECK_RESULT $? 0 0 "Check curvetun -t failed"
    clientKey=$(curvetun -x | sed -n "3p" | awk -F ';' '{print $2}')
    clientStr="tunclient;${clientKey}"
    LOG_INFO ${clientStr}
    SSH_CMD "bash -x /tmp/curvetunServer.sh '${clientStr}'"  ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunServer.info /tmp/curvetunServer.info ${NODE2_PASSWORD}
    serverKey=$(cat /tmp/curvetunServer.info | awk -F "=" '{print $2}')
    serverStr="myfirstserver;${NODE2_IPV4};6666;udp;${serverKey}"
    echo ${serverStr} > ~/.curvetun/servers
    SSH_CMD "nohup curvetun -s -p 6666 -6 -D" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 4
    SLEEP_WAIT 5
    SSH_CMD "ps -ef | grep 'curvetun -s -p' | grep -v 'grep'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check curvetun -D failed"
    SSH_CMD "ps -ef | grep 'curvetun -s -p' | grep -v 'grep'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} > log.info
    pidnum=$(grep "curvetun -s -p 6666" log.info | awk -F " " '{print $2}')
    SSH_CMD "kill -9 ${pidnum}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -f log.info
    SSH_CMD "nohup curvetun -s -p 6666 -6 --nofork" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 4
    SLEEP_WAIT 5
    SSH_CMD "ps -ef | grep 'curvetun -s -p' | grep -v 'grep'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check curvetun --nofork failed"
    SSH_CMD "ps -ef | grep 'curvetun -s -p' | grep -v 'grep'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} > log.info
    pidnum=$(grep "curvetun -s -p 6666" log.info | awk -F " " '{print $2}')
    SSH_CMD "kill -9 ${pidnum}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -f log.info
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    DNF_REMOVE 2
    rm -rf ./data/ ./common/*.sh curvetunServer.info
    LOG_INFO "End to restore the test environment."
}
main "$@"
