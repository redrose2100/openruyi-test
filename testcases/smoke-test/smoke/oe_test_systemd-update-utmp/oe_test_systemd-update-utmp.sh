#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/16
# @License   :   Mulan PSL v2
# @Desc      :   Test systemd-update-utmp
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    # systemd-update-utmp-runlevel.service only exists while runlevel target
    # support is built in; upstream systemd dropped runlevelN.target (and this
    # service) a few releases ago, and openRuyi ships systemd 261 which only
    # provides systemd-update-utmp.service. Assert on the unit that this
    # systemd actually installs, and skip the runlevel variant when absent.
    unit=systemd-update-utmp.service
    ls -l "/usr/lib/systemd/system/${unit}" | grep "${unit}"
    CHECK_RESULT $? 0 0 "${unit} non-existent"
    if [ -e "/usr/lib/systemd/system/systemd-update-utmp-runlevel.service" ]; then
        ls -l /usr/lib/systemd/system/rescue.target.wants/ | grep "systemd-update-utmp-runlevel.service"
        CHECK_RESULT $? 0 0 "systemd-update-utmp-runlevel.service non-existent"
    else
        LOG_INFO "systemd-update-utmp-runlevel.service is not provided by this systemd, skip."
    fi
    LOG_INFO "End to run test."
}

main "$@"
