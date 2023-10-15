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
    SSH_SCP ./common/curvetunServer.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunServer.sh ${NODE2_PASSWORD}
    SSH_SCP ./common/curvetunDepoly.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunDepoly.sh ${NODE2_PASSWORD}
    SSH_SCP ./common/curvetunStartServer.sh ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunStartServer.sh ${NODE2_PASSWORD}
    SSH_CMD "bash -x /tmp/curvetunDepoly.sh" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "bash -x /tmp/curvetunInfo.sh" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunServer.info . ${NODE2_PASSWORD}
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    expect << EOF
        spawn curvetun --keygen
        expect {
            "Username: " {
                send "tunclient\\r"
            }
        }
        expect eof
EOF
    clientKey=$(curvetun -x | sed -n "3p" | awk -F ';' '{print $2}')
    clientStr="tunclient;${clientKey}"
    LOG_INFO ${clientStr}
    SSH_CMD "bash -x /tmp/curvetunServer.sh '${clientStr}'"  ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/tmp/curvetunServer.info /tmp/curvetunServer.info ${NODE2_PASSWORD}
    serverKey=$(cat /tmp/curvetunServer.info | awk -F "=" '{print $2}')
    serverStr="myfirstserver;${NODE2_IPV4};6666;udp;${serverKey}"
    echo ${serverStr} > ~/.curvetun/servers
    curvetun -S | grep "myfirstserver"
    CHECK_RESULT $? 0 0 "Check -S failed"  
    curvetun --dumps | grep "myfirstserver"
    CHECK_RESULT $? 0 0 "Check --dumps failed"
    SSH_CMD " nohup bash -x /tmp/curvetunStartServer.sh '${clientStr}'"  ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 4
    SLEEP_WAIT 5
    curvetun -c=myfirstserver
    CHECK_RESULT $? 0 0 "Check -c failed"
    kill -9 $(ps -ef | grep "curvetun -c" | grep -v "grep" | awk -F " " '{print $2}')
    curvetun --client=myfirstserver
    CHECK_RESULT $? 0 0 "Check --client failed"
    kill -9 $(ps -ef | grep "curvetun --client" | grep -v "grep" | awk -F " " '{print $2}')
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh curvetunServer.info
    SSH_CMD "ps -ef | grep 'curvetun -s -p' | grep -v 'grep'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} > log.info
    pidnum=$(cat log.info  | grep "curvetun -s -p 6666" | awk -F " " '{print $2}')
    SSH_CMD "kill -9 ${pidnum}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -f log.info
    LOG_INFO "End to restore the test environment."
}
main "$@"
