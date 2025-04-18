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
    clean-crl --help | grep "The clean-crl utility"
    CHECK_RESULT $? 0 0 "Check clean-crl --help failed"
    clean-crl -h | grep "The clean-crl utility"
    CHECK_RESULT $? 0 0 "Check clean-crl -h failed"
    clean-crl -V | grep "clean-crl version"
    CHECK_RESULT $? 0 0 "Check clean-crl -V failed"
    clean-crl --version | grep "clean-crl version"
    CHECK_RESULT $? 0 0 "Check clean-crl --version failed"
    fetch-crl -v -l ./data/ && clean-crl -l ./data/ && ls -al ./data/ | grep ".r0"
    CHECK_RESULT $? 1 0 "Check clean-crl -l failed"
    fetch-crl -v -l ./data/ && clean-crl --cadir ./data/ && ls -al ./data/ | grep ".r0"
    CHECK_RESULT $? 1 0 "Check clean-crl --cadir failed"
    fetch-crl -v -l ./data/ && clean-crl -v -l ./data/ | grep "The following CRL like files are about to be deleted"
    CHECK_RESULT $? 0 0 "Check clean-crl -v failed"
    fetch-crl -v -l ./data/ && clean-crl --verbose -l ./data/ | grep "The following CRL like files are about to be deleted"
    CHECK_RESULT $? 0 0 "Check clean-crl --verbose failed"
    fetch-crl -v -l ./data/ && clean-crl -v -n -l ./data/ | grep "The following CRL like files are about to be deleted ... NOT!"
    CHECK_RESULT $? 0 0 "Check clean-crl -n failed"
    fetch-crl -v -l ./data/ && clean-crl -v --dryrun -l ./data/ | grep "The following CRL like files are about to be deleted ... NOT!"
    CHECK_RESULT $? 0 0 "Check clean-crl --dryrun failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
