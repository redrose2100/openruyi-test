#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-09-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/testcases/function-test/pkgs-test/oeAware-manager/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager numactl"
    systemctl restart oeaware
    oeawarectl -i numafast
    cp /etc/numafast.yaml /etc/numafast.yaml_bak
    logfile="/var/log/numafast/numafast.log"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "log-level: \"info\"" /etc/numafast.yaml
    CHECK_RESULT $? 0 0 "Error: Check default log-level failed"
    sed -i 's/log-level:.*/log-level: "trace"/' /etc/numafast.yaml
    numafast --reload
    echo > "${logfile}"
    systemctl restart numafast
    SLEEP_WAIT 3
    grep "TRACE" "${logfile}" && grep "DEBUG" "${logfile}" && grep "INFO" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log-level is trace include relation failed"
    sed -i 's/log-level:.*/log-level: "debug"/' /etc/numafast.yaml
    numafast --reload
    echo > "${logfile}"
    systemctl restart numafast
    SLEEP_WAIT 3
    grep "DEBUG" "${logfile}" && grep "INFO" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log-level is debug include relation failed"
    sed -i 's/log-level:.*/log-level: "info"/' /etc/numafast.yaml
    numafast --reload
    echo > "${logfile}"
    systemctl restart numafast
    SLEEP_WAIT 3
    grep "INFO" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log-level is info include relation failed"
    sed -i 's/log-level:.*/log-level: "err"/' /etc/numafast.yaml
    numafast --reload | grep "yaml config parse failed, will use default value"
    CHECK_RESULT $? 0 0 "Error: Check set log-level is not exists failed"
    systemctl restart numafast
    echo > "${logfile}"
    SLEEP_WAIT 3
    grep "INFO" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log-level is info include relation failed"
    sed -i 's/log-level:.*/log-level: ""/' /etc/numafast.yaml
    numafast --reload | grep "yaml config parse failed, will use default value"
    CHECK_RESULT $? 0 0 "Error: Check log-level is not set failed"
    systemctl restart numafast
    echo > "${logfile}"
    SLEEP_WAIT 3
    grep "INFO" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log-level is info include relation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop numafast
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
