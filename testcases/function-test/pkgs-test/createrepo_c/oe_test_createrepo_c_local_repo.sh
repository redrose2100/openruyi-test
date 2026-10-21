#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/04
# @License   :   Mulan PSL v2
# @Desc      :   Test createrepo_c make repo
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL createrepo_c
    test_path=/tmp/test
    repo_path=/etc/yum.repos.d
    mkdir ${test_path} ${repo_path}/bak
    cd ${test_path}
    yum download git git-core perl-Error perl-Git perl-TermReadKey
    mv /etc/yum.repos.d/*.repo ${repo_path}/bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    createrepo_c .
    test -e repodata
    CHECK_RESULT $? 0 0 "Generation failure"
    cat > ${repo_path}/local.repo << EOF
[local]
name= local repo
baseurl=file://${test_path}
enabled=1
gpgcheck=0
EOF
    yum --disablerepo="*" --enablerepo="local" list available
    CHECK_RESULT $? 0 0 "Repo error"
    yum clean all
    yum install git -y
    CHECK_RESULT $? 0 0 "Package install fail"
    yum remove git -y
    CHECK_RESULT $? 0 0 "Package remove fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    mv ${repo_path}/bak/* ${repo_path}
    rm -rf ${test_path} ${repo_path}/local.repo ${repo_path}/bak
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"