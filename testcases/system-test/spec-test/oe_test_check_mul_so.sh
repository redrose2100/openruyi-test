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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2023/02/01
# @License   :   Mulan PSL v2
# @Desc      :   Multi-dynamic library troubleshooting
# ############################################
# shellcheck disable=SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    EXECUTE_T="600m"
    DNF_INSTALL rpm-build
    mkdir /root/source
    dnf list --available --repo="source" | grep oe | awk '{print $1}' | awk -F '.src' '{print $1}' >pack_list
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    while read -r pack_name; do
        yumdownloader --source --destdir /root/source "$pack_name" >>/dev/null 2>&1
        if [[ "clang12 compiler-rt12 libomp12 llvm12 llvm-mlir12" =~ ${pack_name} ]]; then
            test -d /root/rpmbuild/SPECS/ && mv /root/rpmbuild/SPECS/ /root
            rpm -ivh /root/source/"${pack_name}"* >>/dev/null 2>&1
            mv /root/rpmbuild/SPECS/*.spec /root/rpmbuild/SPECS/"${pack_name}"12.spec
            test -d /root/SPECS && cp /root/SPECS/* /root/rpmbuild/SPECS/
            test -d /root/SPECS && rm -rf /root/SPECS
        else
            rpm -ivh /root/source/"${pack_name}"* >>/dev/null 2>&1
        fi
        rm -rf /root/rpmbuild/SOURCES
    done <pack_list
    find /root/rpmbuild/SPECS/ -name '*.spec' -print0 | xargs -0 grep -wn cp | grep -E 'buildroot|RPM_BUILD_ROOT' | grep -F '*' | grep -w so | grep libdir | grep "cp -. ...libdir" >spec_check_result
    test -s spec_check_result
    CHECK_RESULT $? 1 0 "Non-compliant software package exists"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    rm -rf pack_list spec_check_result /root/rpmbuild /root/source
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
