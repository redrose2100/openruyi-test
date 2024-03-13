#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-08-15
#@License       :   Mulan PSL v2
#@Desc          :   gpgkey check for rpms
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    rm -rf ./*.rpm
    DNF_INSTALL "createrepo dnf-plugins-core"
    rpm -qa |grep gpg-pubkey || rpm --import "$(rpm -qa |grep gpg-keys |xargs rpm -ql |grep -i euler)"
    yumdownloader libatomic
    wget https://rpmfind.net/linux/centos/8-stream/BaseOS/"$(arch)"/os/Packages/libatomic-8.5.0-20.el8."$(arch)".rpm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -K "$(ls libatomic*oe*)" | grep "digests signatures OK"
    CHECK_RESULT $? 0 0 "Failed to check RPM signature"
    yum install -y "$(ls libatomic*oe*)"
    CHECK_RESULT $? 0 0 "Failed to localinstall rpm"
    yum remove -y libatomic

    rpm -K "$(ls libatomic*el8*)" | grep "digests SIGNATURES NOT OK"
    CHECK_RESULT $? 0 0 "Failed to check RPM signature"
    yum install -y "$(ls libatomic*el8*)"
    CHECK_RESULT $? 0 0 "Failed to localinstall rpm"
    yum remove -y libatomic

    rpm -e gpg-pubkey
    mkdir el8;mv "$(ls libatomic*el8*)" el8;createrepo el8
    sed -i "s#el8_path#$(realpath el8)#g" common/test.repo
    cp common/test.repo /etc/yum.repos.d/;yum clean all
    yum --repo=el8 install -y libatomic
    CHECK_RESULT $? 0 1 "Failed to check rpm gpgkey"

    sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/test.repo
    yum --repo=el8 install -y libatomic
    CHECK_RESULT $? 0 0 "Failed to check rpm gpgkey"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    yum remove -y libatomic
    DNF_REMOVE "$@"
    rm -rf ./*.rpm ./el8 /etc/yum.repos.d/test.repo
    export LANG=$Default_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
