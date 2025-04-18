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
# shellcheck disable=SC2010,SC2012,SC2046
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fetch-crl tar"
    tar -xvf common/data.tar.gz >/dev/null
    cp -f ./data/KEK.crl_url /etc/grid-security/certificates
    cp -f ./data/KEK.pem /etc/grid-security/certificates
    mkdir -p ./tmp1 ./tmp2 ./tmp3 ./tmp4
    systemctl start fetch-crl.service
    SLEEP_WAIT 2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fetch-crl -q -l ./data/
    CHECK_RESULT $? 0 0 "Check fetch-crl -q failed"
    fetch-crl --quiet -l ./data/
    CHECK_RESULT $? 0 0 "Check fetch-crl --quiet failed"
    fetch-crl --cadir ./data/ -l ./data/
    CHECK_RESULT $? 0 0 "Check fetch-crl --cadir failed"
    fetch-crl -l ./data/ -s ./tmp1 && ls -al ./tmp1/ | grep ".0.state"
    CHECK_RESULT $? 0 0 "Check fetch-crl -s failed"
    fetch-crl -l ./data/ --statedir ./tmp2 && ls -al ./tmp2/ | grep ".0.state"
    CHECK_RESULT $? 0 0 "Check fetch-crl --statedir failed"
    fetch-crl -T 100 -l ./data/
    CHECK_RESULT $? 0 0 "Check fetch-crl -T failed"
    fetch-crl --httptimeout 1 -l ./data/
    CHECK_RESULT $? 0 0 "Check fetch-crl --httptimeout failed"
    fetch-crl --output ./tmp3 -l ./data/ && test $(ls ./tmp3/ | wc -l) -gt 0
    CHECK_RESULT $? 0 0 "Check fetch-crl --output failed"
    fetch-crl -o ./tmp4 -l ./data/ && test $(ls ./tmp4/ | wc -l) -gt 0
    CHECK_RESULT $? 0 0 "Check fetch-crl -o failed"
    fetch-crl --format pem -l ./data/ && ls -al ./data/ | grep ".0.crl.pem"
    CHECK_RESULT $? 0 0 "Check fetch-crl --format failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data ./tmp*
    LOG_INFO "End to restore the test environment."
}

main "$@"
