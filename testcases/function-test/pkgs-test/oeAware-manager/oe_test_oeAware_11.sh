#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager numactl"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    sed -i -e '/name: / s/: .*/: ''/' /etc/oeAware/config.yaml
    sed -i '/description:/,/url:/{/description:/!{/url:/!d}}' /etc/oeAware/config.yaml
    sed -i -e '/description: / s/: .*/: ''/' /etc/oeAware/config.yaml
    sed -i -e '/url: / s/: .*/: ''/' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 1
    systemctl status | grep "null name in plugin_list"
    CHECK_RESULT $? 0 0 "service log is wrong"

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    sed -i -e '/url: / s/: .*/: ''/' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 1
    systemctl status | grep "null url in plugin_list"
    CHECK_RESULT $? 0 0 "service log is wrong"

    oeawarectl --install numafast3 | grep "Download failed, because unable to find a match: numafast3"
    CHECK_RESULT $? 0 0 "Error: download package" 

    if [ "$NODE1_FRAME" == "aarch64" ]; then

        \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
        url="https://repo.oepkgs.net/openeuler/rpm/openEuler-22.03-LTS-SP10/extras/aarch64/Packages/n/numafast-v1.0.0-2.aarch64.rpm"
        sed -i 's#url:.*#url: '"${url}"'#' /etc/oeAware/config.yaml
        systemctl restart oeaware
        SLEEP_WAIT 1
        oeawarectl --install numafast | grep "Download failed, please check url or your network"
        CHECK_RESULT $? 0 0 "Error: download package" 
    fi

        
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    DNF_REMOVE "$@"
    rpm -e numafast
    rm -rf /etc/oeAware/config_ori.yaml numafast
    LOG_INFO "End to restore the test environment."
}

main "$@"
