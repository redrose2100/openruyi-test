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
# shellcheck disable=SC2034,SC2154,SC1091

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ./compile.conf
source "${OET_PATH}"/libs/locallibs/configure_repo.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    EXECUTE_T="600m"
    pretty_name=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2- | tr -d '"')
    version_info=$(echo "$pretty_name" | sed -E 's/ \(.*\)/-\1/; s/ /-/g; s/[()]//g')
    test -z "${test_repo}" || official_repo=${test_repo}
    mv -f /etc/yum.repos.d/*.repo ./
    if [ "${test_mode}" == "update" ]; then
        cfg_openEuler_repo
        cfg_openEuler_update_test_repo
        dnf list --available --repo="${version_info}_source_${test_update_repo}" | grep oe | awk '{print $1}' | awk -F '.src' '{print $1}' >source_list
    else
        cfg_openEuler_repo
        sed -i '/source\/.*/!b;n;cenabled=0' /etc/yum.repos.d/"${version_info}".repo
        sed -i '/update\/.*/!b;n;cenabled=0' /etc/yum.repos.d/"${version_info}".repo
        sed -i "/.*${version_info}\/source\//!b;n;cenabled=1" /etc/yum.repos.d/"${version_info}".repo
        if [ "${test_time}" ]; then
            sed -i "s/${version_info}\//${version_info}\/${test_time}\//g" /etc/yum.repos.d/"${version_info}".repo
        else
            LOG_INFO "Nothing to do."
        fi
        if [ "${test_repo_source}" ]; then
            sed -i "/name=${version_info}_source.*/!b;n;cbaseurl=${test_repo_source}" /etc/yum.repos.d/"${version_info}".repo
        else
            LOG_INFO "Nothing to do."
        fi
        dnf list --available --repo="${version_info}_source" | grep oe | awk '{print $1}' | awk -F '.src' '{print $1}' | grep -vE "kernel|gcc|glibc" >source_list.bak
        shuf -n"${test_pkg_num}" source_list.bak >source_list
        sed -i "1i kernel\ngcc\nglibc" source_list
    fi
    if [ "${test_type}" == "single" ]; then
        echo -e "${test_pkg_name}" >source_list
    else
        LOG_INFO "Test all software packages"
    fi
    DNF_INSTALL "rpm-build make python3-gssapi"
    useradd compileuser
    mkdir /home/compileuser/source
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    while read -r source_name; do
        if [[ "${skip_pkg_name}" =~ ${source_name} ]]; then
            LOG_INFO "Skip package named ${source_name}" >/home/compileuser/"${source_name}".log
        else
            yumdownloader --source --destdir /home/compileuser/source "${source_name}".src >>/dev/null 2>&1
            CHECK_RESULT $? 0 0 "yumdownloader \"${source_name}\".src failed"
            su - compileuser -c "rpm -ivh /home/compileuser/source/${source_name}* >>/dev/null 2>&1"
            CHECK_RESULT $? 0 0 "install \"${source_name}\" failed"
            yum builddep --assumeno /home/compileuser/rpmbuild/SPECS/*.spec 2>&1 | grep "root" && rpm -ivh /home/compileuser/source/"${source_name}"*
            yum builddep --assumeno /home/compileuser/rpmbuild/SPECS/*.spec 2>&1 | sed '/Upgrading:/,+100000d' | sed '/Installing dependencies:/,+100000d' | grep -v "Operation aborted." | grep Installing: -A 10000 | grep oe | awk '{print $1}' >dep_list
            yum builddep -y /home/compileuser/rpmbuild/SPECS/*.spec >builddep.log
            CHECK_RESULT $? 0 0 "install builddep \"${source_name}\" failed"
            su - compileuser -c "rpmbuild -ba /home/compileuser/rpmbuild/SPECS/*.spec >${source_name}.log 2>&1"
            CHECK_RESULT $? 0 0 "rpmbuild \"${source_name}\" failed"
        fi
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
    rm -rf /home/compileuser/rpmbuild /home/compileuser/source /home/compileuser/*.log source_list builddep.log source_list.bak /etc/yum.repos.d/"${version_info}".repo
    mv -f ./*.repo /etc/yum.repos.d/
    export LANG=${OLD_LANG}
    userdel -rf compileuser
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
