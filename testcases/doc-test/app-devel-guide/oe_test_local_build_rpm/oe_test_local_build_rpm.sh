#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   test_build_rpm_FUN
# @Author    :   dingjiao
# @Contact   :   ding_jiao@@hoperun.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Building RPM software packages locally
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "rpmdevtools*"
    rpmdev-setuptree
    cp ../common/hello.spec ~/rpmbuild/SPECS
    cd ~/rpmbuild/SOURCES && wget http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    rpmbuild -ba ~/rpmbuild/SPECS/hello.spec
    CHECK_RESULT $? 0 0 "Failed to build RPM package"
    tree ~/rpmbuild/*RPMS | grep "/root/rpmbuild/SRPMS\|hello-2.10-1.src.rpm"
    CHECK_RESULT $? 0 0 "Failed to check SRPMS file"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf ~/rpmbuild
    DNF_REMOVE "$@"
    LOG_INFO "End environment cleanup."
}

main "$@"
