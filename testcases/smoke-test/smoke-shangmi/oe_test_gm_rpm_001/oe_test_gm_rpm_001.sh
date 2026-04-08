#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zhangjinqiang 
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/10/23
# @Desc      :   rpm sm test
# ##################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to run test."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "libgcrypt gnupg2 rpm"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gpg --batch --passphrase "" --quick-generate-key rpm-gm sm2p256v1
    CHECK_RESULT $? 0 0 "generate key failed"
    gpg -o sm2_public.asc --armor --export rpm-gm
    CHECK_RESULT $? 0 0 "export public key failed"
    rpm --define "_enable_sm2p256v1_sm3_algo 1" --import sm2_public.asc
    CHECK_RESULT $? 0 0 "import gpg key to rpm database failed"
    rpm -qa 'gpg-pubkey*' --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | grep rpm-gm
    CHECK_RESULT $? 0 0 "check gpg key in rpm database failed"
    dnf download wget
    CHECK_RESULT $? 0 0 "download package failed"
    mv "$(dnf download wget --quiet --url | xargs basename)" wget.rpm
    CHECK_RESULT $? 0 0 "rename package failed"
    rpm --define "_enable_sm2p256v1_sm3_algo 1" --define "_gpg_name rpm-gm" --addsign wget.rpm
    CHECK_RESULT $? 0 0 "sign package failed"
    rpm --define "_enable_sm2p256v1_sm3_algo 1" -Kv wget.rpm | grep "Header V4 ECDSA/SM3 Signature"
    CHECK_RESULT $? 0 0 "verify package signature failed"
    gpg --sign wget.rpm
    CHECK_RESULT $? 0 0 "gpg sign package failed"
    gpg --verify wget.rpm.gpg
    CHECK_RESULT $? 0 0 "gpg verify package signature failed"
    gpg --detach-sign --output wget.rpm.sig wget.rpm
    CHECK_RESULT $? 0 0 "gpg detach sign package failed"
    gpg --verify wget.rpm.sig wget.rpm
    CHECK_RESULT $? 0 0 "gpg verify detach signature failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm wget.rpm* sm2_public.asc
    fingerprint=$(gpg --with-colons --fingerprint rpm-gm | awk -F: '/^fpr:/ {print $10}')
    gpg --batch --yes --delete-secret-keys "$fingerprint"
    gpg --batch --yes --delete-keys "$fingerprint"
    rpm -qa 'gpg-pubkey*' --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | grep rpm-gm | awk '{print $1}' | xargs rpm -e
    export LANG=$cur_lang
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

