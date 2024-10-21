#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
# http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_pre_repo_source_file
# @Author    :   dingjiao
# @Contact   :   dingjiao@hoperun.com
# @Date      :   2024-10-20
# @License   :   Mulan PSL v2
# @Desc      :   Prepare the development environment
# ############################################
# shellcheck disable=SC2012,SC2027,SC1078,SC1079,SC1132,SC2034
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    repo_version=$(grep openeulerversion /etc/openEuler-latest | awk -F '=' '{print'"$NF"'}')
    jdk_version=$(dnf search openjdk-devel | awk -F '-' 'NR==2{print $2}')
    jdk_name=java-"$jdk_version"-openjdk-devel.${NODE1_FRAME}
    dnf list installed | grep "$jdk_name" && DNF_REMOVE "$jdk_name"
    dnf list installed | grep "rpm-build" && DNF_REMOVE "rpm-build"
    wget https://download.jetbrains.com/idea/ideaIC-2018.3.6.tar.gz?_gl=1*v7yw3v*_ga*MTcwODc3NTgzLjE2OTIyMzk3NDU.*_ga_9J976DJZ68*MTY5MzM4NTgzMi4zLjEuMTY5MzM4NTkwOS4wLjAuMA..&_ga=2.235897538.2144001725.1693378868-170877583.1692239745
    tar xf ideaIC-2018.3.6.tar.gz
    LOG_INFO "End to prepare the test environment!"
}
function run_test() {
    LOG_INFO "Start executing testcase!"
    echo "
[osrepo]
name=osrepo
baseurl=http://repo.openeuler.org/""$repo_version""/OS/""${NODE1_FRAME}""/
enabled=1
gpgcheck=1
gpgkey=http://repo.openeuler.org/""$repo_version""/OS/""${NODE1_FRAME}""/RPM-GPG-KEY-openEuler
    " >>/etc/yum.repos.d/local_repo
    CHECK_RESULT $? 0 0 "Failed to set repo!"
    dnf clean all
    CHECK_RESULT $? 0 0 "Clearing cache failed"
    dnf makecache
    CHECK_RESULT $? 0 0 "Failed to create cache"
    dnf install -y "$jdk_name"
    CHECK_RESULT $? 0 0 "Failed to install jdk"
    java -version 2>&1 | grep "$jdk_version"
    CHECK_RESULT $? 0 0 "JDK version error"
    dnf clean all
    CHECK_RESULT $? 0 0 "Clearing cache failed"
    dnf makecache
    CHECK_RESULT $? 0 0 "Failed to create cache"
    dnf install -y rpm-build
    CHECK_RESULT $? 0 0 "Failed to install rpm!"
    rpm_build_version=$(rpm -qa | grep rpm-build | awk -F '-' '{print $3}')
    rpmbuild --version | grep "$rpm_build_version"
    CHECK_RESULT $? 0 0 "rpm-build version error!"
    which java | grep /usr/bin/java
    CHECK_RESULT $? 0 0 "Java path error!"
    java_path1=$(ls -la /usr/bin/java | awk -F '-> ' '{print $2}')
    actual_path=$(ls -la "$java_path1" | awk -F '-> ' '{print $2}' | awk -F '/jre' '{print $1}')
    export JAVA_HOME=$actual_path
    CHECK_RESULT $? 0 0 "Set java_home path error!"
    export PATH=$JAVA_HOME/bin:$PATH
    CHECK_RESULT $? 0 0 "Set PATH error!"
    DNF_INSTALL "gtk2 libXtst libXrender xauth"
    CHECK_RESULT $? 0 0 "Install GTK library!"
    test -d ~/.ssh || mkdir ~/.ssh
    CHECK_RESULT $? 0 0 "Failed to create ssh directory!"
    echo "Host *
            ForwardAgent yes
            ForwardX11 yes" >>~/.ssh/config
    CHECK_RESULT $? 0 0 "Failed to set config file!"
    cd idea-IC-183.6156.11/ && ./bin/idea.sh &
    CHECK_RESULT $? 0 0 "Failed to run IntelliJ IDEA!"
    LOG_INFO "End of testcase execution!"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/yum.repos.d/local_repo ~/.ssh ideaIC-2018.3.6*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
