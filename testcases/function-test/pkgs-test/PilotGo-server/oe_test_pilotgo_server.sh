#!/usr/bin/bash
# Copyright (c) 2026. OpenAtom Foundation.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2026/09/08
# @License   :   Mulan PSL v2
# @Desc      :   pilotgo-server systemd service test
# ############################################
# shellcheck disable=SC1091,SC2120
source "common/pilotgo_common.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    pilotgo_prepare_base_server
    LOG_INFO "End environment preparation."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    test_restart PilotGo-server.service
    test_enabled PilotGo-server.service
    test_reload PilotGo-server.service
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    pilotgo_cleanup_base_server
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
