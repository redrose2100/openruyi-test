#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-11-2
#@License       :   Mulan PSL v2
#@Desc          :   OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
#####################################
# shellcheck disable=SC1091
# shellcheck disable=SC2154
source "common/common_osc.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    osc checkout "${branches_path}" | grep 'revision'
    cd "${branches_path}" || exit 1
    user_name=$(grep user /root/.config/osc/oscrc | awk -F '=' '{print $NF}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    osc mkpac xzz | grep 'xzz'
    osc commit -m "create new package" | grep 'Sending'
    osc token
    CHECK_RESULT $?
    osc whois | grep "$user_name"
    CHECK_RESULT $?
    osc copypac  Apache apr "${branches_path}" apr  | grep 'comment'
    CHECK_RESULT $?
    osc up | grep 'checking out new package'
    CHECK_RESULT $?
    osc aggregatepac openSUSE:Factory 7kaa "${branches_path}" xzz | grep 'Creating _aggregate'
    CHECK_RESULT $?
    osc up | grep "Updating"
    CHECK_RESULT $?
    osc linkpac Apache apr "${branches_path}" xzz | grep 'Creating _link'
    CHECK_RESULT $?
    osc up | grep "Updating"
    CHECK_RESULT $?
    cd xzz || exit 1
    if [ "$FRAME" = "aarch64" ]; then
        osc buildinfo | grep 'buildinfo'
        CHECK_RESULT $?
    fi
    osc linktobranch | grep 'revision'
    CHECK_RESULT $?
    osc pdiff
    CHECK_RESULT $?
    cd .. || exit 1
    osc rdelete "$branches_path" apr -m "delete package_apr"
    osc rdelete "$branches_path" xzz -m "delete package_xzz"
    osc commit -n
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
