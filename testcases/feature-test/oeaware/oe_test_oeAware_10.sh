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
#@Date          :   2024-06-12
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    DNF_INSTALL "oeAware-manager numactl"
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    source /etc/openEuler-latest
    os_version=${openeulerversion}
    address="https://repo.oepkgs.net/openeuler/rpm/$os_version/extras/$NODE_FRAME/Packages/n/"
    wget $address
    software=`cat index.html  | grep numafast | cut -d '>' -f 1 | awk -F '"' '{print$2}'`
    sed -i '/plugin_list/a\  - name: numafast2\n    description: numafast2' /etc/oeAware/config.yaml
    url="https://repo.oepkgs.net/openeuler/rpm/$os_version/extras/$NODE_FRAME/Packages/n/$software"
    url="${url//\//\\\/}"
    sed -i '/description: numafast2/a\    url: '"$url"' ' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 1
    oeawarectl --list | grep "numafast2"
    CHECK_RESULT $? 0 0 "numafast2 is not found in oeawarectl --list"
    oeawarectl --install numafast2 | grep "numafast"
    CHECK_RESULT $? 0 0 "numafast2 install failed" 
    rm -rf index.html
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    rm -rf /etc/oeAware/config_ori.yaml
    DNF_REMOVE "$@"
    rpm -e numafast
    LOG_INFO "End to restore the test environment."
}

main "$@"
