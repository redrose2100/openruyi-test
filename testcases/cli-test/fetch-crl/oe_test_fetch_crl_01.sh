#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test fetch-crl
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fetch-crl tar"
    tar -xvf common/data.tar.gz >/dev/null
    cp -f ./data/KEK.crl_url /etc/grid-security/certificates
    cp -f ./data/KEK.pem /etc/grid-security/certificates
    systemctl start fetch-crl.service
    SLEEP_WAIT 2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fetch-crl --help | grep "Usage: fetch-crl"
    CHECK_RESULT $? 0 0 "Check fetch-crl --help failed"
    fetch-crl -h | grep "Usage: fetch-crl"
    CHECK_RESULT $? 0 0 "Check fetch-crl --help failed"
    fetch-crl -V | grep "fetch-crl version"
    CHECK_RESULT $? 0 0 "Check fetch-crl -V failed"
    fetch-crl --version | grep "fetch-crl version"
    CHECK_RESULT $? 0 0 "Check fetch-crl --version failed"
    fetch-crl -v -l ./data/ | grep "Initializing trust"
    CHECK_RESULT $? 0 0 "Check fetch-crl -l failed"
    fetch-crl -v --infodir ./data/ | grep "Initializing trust"
    CHECK_RESULT $? 0 0 "Check fetch-crl --infodir failed"
    cp -f ./data/KEK.crl_url /etc/grid-security/certificates
    cp -f ./data/KEK.pem /etc/grid-security/certificates
    fetch-crl -c /etc/fetch-crl.conf
    CHECK_RESULT $? 0 0 "Check fetch-crl -c failed"
    fetch-crl --config /etc/fetch-crl.conf
    CHECK_RESULT $? 0 0 "Check fetch-crl --config failed"
    fetch-crl -v -l ./data/ | grep "Initializing trust"
    CHECK_RESULT $? 0 0 "Check fetch-crl -v failed"
    fetch-crl --verbose -l ./data/ | grep "Initializing trust"
    CHECK_RESULT $? 0 0 "Check fetch-crl --verbose failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /etc/grid-security/certificates ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
