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
# @Date      :   2023/07/06
# @License   :   Mulan PSL v2
# @Desc      :   Compile
# ############################################
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC1091

source ./common_compile.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    EXECUTE_T="600m"
    mv -f /etc/yum.repos.d/*.repo ./
    if [ "${test_mode}" == "update" ]; then
        configure_update_repo "${openeulerversion}"
        dnf list --available --repo="source" | grep oe | awk '{print $1}' | awk -F. '{print $1}' >source_list
    else
        configure_round_repo "${openeulerversion}"
        dnf list --available --repo="source" | grep oe | awk '{print $1}' | awk -F. '{print $1}' | grep -vE "kernel|gcc|glibc" >source_list.bak
        shuf -n"${pkg_name}" source_list.bak >source_list
        sed -i "1i kernel\ngcc\nglibc" source_list
    fi
    useradd compileuser
    DNF_INSTALL "rpm-build make python3-gssapi"
    mkdir /home/compileuser/source
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    while read -r source_name; do
        yumdownloader --source --destdir /home/compileuser/source "${source_name}".src >>/dev/null 2>&1
        CHECK_RESULT $? 0 0 "yumdownloader \"${source_name}\".src failed"
        su - compileuser -c "rpm -ivh /home/compileuser/source/${source_name}* >>/dev/null 2>&1"
        CHECK_RESULT $? 0 0 "install \"${source_name}\" failed"
        yum builddep --assumeno /home/compileuser/rpmbuild/SPECS/"${source_name}".spec 2>&1 | grep "root" && rpm -ivh /home/compileuser/source/"${source_name}"*
        yum builddep --assumeno /home/compileuser/rpmbuild/SPECS/"${source_name}".spec 2>&1 | sed '/Upgrading:/,+100000d' | sed '/Installing dependencies:/,+100000d' | grep -v "Operation aborted." | grep Installing: -A 10000 | grep oe | awk '{print $1}' >dep_list
        yum builddep -y /home/compileuser/rpmbuild/SPECS/"${source_name}".spec >builddep.log
        CHECK_RESULT $? 0 0 "install builddep \"${source_name}\" failed"
        su - compileuser -c "rpmbuild -ba /home/compileuser/rpmbuild/SPECS/${source_name}.spec >${source_name}.log 2>&1"
        CHECK_RESULT $? 0 0 "rpmbuild \"${source_name}\" failed"
        tail -n 1 /home/compileuser/"${source_name}".log | grep "xit 0"
        CHECK_RESULT $? 0 0 "complie \"${source_name}\" failed"
        while read -r dep_name; do
            yum remove -y "${dep_name}"
        done <dep_list
        rm -rf /home/compileuser/rpmbuild /home/compileuser/source /home/compileuser/"${source_name}".log dep_list /root/rpmbuild
    done <source_list
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /home/compileuser/rpmbuild /home/compileuser/source /home/compileuser/*.log source_list builddep.log source_list.bak
    mv -f ./*.repo /etc/yum.repos.d/
    export LANG=${OLD_LANG}
    userdel -rf compileuser
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
