#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test speech-dispatcherd.service restart
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    if ! lspci | grep -i audio; then
        LOG_INFO "The environment does not support test"
        exit 0
    else
        DNF_INSTALL "speech-dispatcher alsa-utils"
        rpm -e --nodeps pulseaudio
        flag=false
        if getenforce | grep -q Enforcing; then
            setenforce 0
            flag=true
        fi
        sed -i 's/# AudioOutputMethod "pulse"/AudioOutputMethod "alsa"/g' /etc/speech-dispatcher/speechd.conf
        sed -i 's/# Timeout 5/Timeout 0/g' /etc/speech-dispatcher/speechd.conf
        systemctl restart alsa-state.service
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution speech-dispatcherd.service
    test_reload speech-dispatcherd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environmental preparation."
    sed -i 's/AudioOutputMethod "alse"/# AudioOutputMethod "pulse"/g' /etc/speech-dispatcher/speechd.conf
    sed -i 's/Timeout 0/# Timeout 5/g' /etc/speech-dispatcher/speechd.conf
    systemctl stop alsa-state.service
    systemctl stop speech-dispatcherd.service
    if [ "${flag}" = "true" ]; then
        setenforce 1
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End of environmental preparation!"
}

main "$@"
