#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2025/08/29
# @License   :   Mulan PSL v2
# @Desc      :   ActiveMQ JMS(OpenWire) connectivity test
# ############################################
# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "activemq java-1.8.0-openjdk java-1.8.0-openjdk-devel telnet net-tools"
    cd /usr/share/activemq/bin || exit 1
    chmod +x ./activemq
    ./activemq start
    if [ "${NODE1_FRAME}" == "riscv64" ] ; then
        SLEEP_WAIT 180
    else
        SLEEP_WAIT 10
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run JMS connectivity test."
    
    # Test if ActiveMQ client libraries are available
    if [ -d "/usr/share/activemq/lib" ] && [ -n "$(ls -A /usr/share/activemq/lib/*.jar 2>/dev/null)" ]; then
        LOG_INFO "ActiveMQ client libraries are available"
    else
        CHECK_RESULT $? 0 0 "ActiveMQ client libraries not found"
    fi
    
    # Test 2: Verify ActiveMQConnectionFactory class exists in JAR files
    find /usr/share/activemq/lib -name "*.jar" -exec jar -tf {} \; | grep -q "org/apache/activemq/ActiveMQConnectionFactory.class"
    CHECK_RESULT $? 0 0 "ActiveMQConnectionFactory class cannot be found in JAR files"
    
    # Test 3: Test OpenWire port accessibility
    local port_accessible=1
    if netstat -tln | grep -q ":61616 "; then
        port_accessible=0
        LOG_INFO "Port 61616 is listening"
    else
        LOG_ERROR "Port 61616 is not listening"
        port_accessible=1
    fi
    CHECK_RESULT $port_accessible 0 0 "OpenWire port 61616 not accessible"
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ./activemq stop >/dev/null 2>&1 || true
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
