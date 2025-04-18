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
# shellcheck disable=SC2010
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
    fetch-crl --format pem -l ./data/ -p 2 && ls -al ./data/ | grep ".0.crl.pem"
    CHECK_RESULT $? 0 0 "Check fetch-crl -p failed"
    rm -f ./data/*.0.crl.pem
    fetch-crl --format pem -l ./data/ --parallelism 2 && ls -al ./data/ | grep ".0.crl.pem"
    CHECK_RESULT $? 0 0 "Check fetch-crl --parallelism failed"
    rm -f ./data/*.0.crl.pem
    fetch-crl --format pem -l ./data/ --randomwait 20 && ls -al ./data/ | grep ".0.crl.pem"
    CHECK_RESULT $? 0 0 "Check fetch-crl --randomwait failed"
    rm -f ./data/*.0.crl.pem
    fetch-crl --format pem -l ./data/ -r 20 && ls -al ./data/ | grep ".0.crl.pem"
    CHECK_RESULT $? 0 0 "Check fetch-crl -r failed"
    rm -f ./data/*.0.crl.pem
    fetch-crl --nosymlinks -l ./data/ && ls -al ./data/ | grep ".r0"
    CHECK_RESULT $? 0 0 "Check fetch-crl --nosymlinks failed"
    rm -f ./data/*.r0
    fetch-crl --agingtolerance 168 -l ./data/ && ls -al ./data/ | grep ".r0"
    CHECK_RESULT $? 0 0 "Check fetch-crl --agingtolerance failed"
    rm -f ./data/*.r0
    fetch-crl -a 168 -l ./data/ && ls -al ./data/ | grep ".r0"
    CHECK_RESULT $? 0 0 "Check fetch-crl -a failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
