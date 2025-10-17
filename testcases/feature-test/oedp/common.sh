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
#@Author        :   dingjiao
#@Contact       :   ding_jiao@hoperun.com
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oedeploy test
#####################################
# shellcheck disable=SC2010,SC2143,SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_oedp() {
    LOG_INFO "Start to prepare the test environment."
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    oedp_version=$(uname -r | awk -F '.' '{print $(NF-1)}')
    BASE_URL="https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/noarch"
    RPM_FILE=$(curl -s "$BASE_URL/" | grep -o "oedp-[^\"]*\.${oedp_version}\.noarch\.rpm" | head -1)

    if [ -n "$RPM_FILE" ]; then
        echo "下载: $RPM_FILE"
        wget "$BASE_URL/$RPM_FILE"
    else
        echo "未找到匹配的RPM包"
        exit 1
    fi
    yum install -y "$RPM_FILE"
    LOG_INFO "End to prepare the test environment."
}

function post_oedp() {
    LOG_INFO "Start to restore the test environment."
    export LANG="${LANG_OLD}"
    oedp_name=$(yum list installed | grep oedp | awk '{print $1}')
    yum remove -y "$oedp_name"
    rm -rf "$RPM_FILE"*
    LOG_INFO "End to restore the test environment."
}

