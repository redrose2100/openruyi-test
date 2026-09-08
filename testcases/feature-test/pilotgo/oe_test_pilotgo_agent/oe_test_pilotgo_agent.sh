#!/usr/bin/bash
# Copyright (c) 2026. OpenAtom Foundation.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2026/09/08
# @License   :   Mulan PSL v2
# @Desc      :   pilotgo-agent systemd service test
# ############################################
# shellcheck disable=SC1091
source "${OET_PATH}/testcases/feature-test/pilotgo/common/pilotgo_common.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    pilotgo_prepare_base_server
    DNF_INSTALL PilotGo-agent

    cp /opt/PilotGo/agent/config_agent.yaml /opt/PilotGo/agent/config_agent.yaml.bak
    LOG_INFO "End environment preparation."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    systemctl restart PilotGo-agent
    CHECK_RESULT $?
    SLEEP_WAIT 5
    systemctl is-active PilotGo-agent | grep -w active
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop PilotGo-agent
    cp /opt/PilotGo/agent/config_agent.yaml.bak /opt/PilotGo/agent/config_agent.yaml
    rm -f /opt/PilotGo/agent/config_agent.yaml.bak
    pilotgo_cleanup_base_server
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
