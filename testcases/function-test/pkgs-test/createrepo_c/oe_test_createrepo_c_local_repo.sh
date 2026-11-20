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
    # git 依赖 /usr/bin/perl 与 git-core-doc，下载列表必须包含它们，否则本地仓库无法解析
    yum download git git-core git-core-doc perl perl-Error perl-Git perl-TermReadKey
    mv /etc/yum.repos.d/*.repo ${repo_path}/bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # 生成 filelists 元数据，否则 /usr/bin/perl 这类文件依赖无法被本地仓库满足
    createrepo_c --database --filelists .
    test -e repodata
    CHECK_RESULT $? 0 0 "Generation failure"
    cat > ${repo_path}/local.repo << EOF
[local]
name= local repo
baseurl=file://${test_path}
enabled=1
gpgcheck=0
EOF
    yum --disablerepo="*" --enablerepo="local" repolist
    CHECK_RESULT $? 0 0 "Repo error"
    yum --disablerepo="*" --enablerepo="local" repolist | grep -q "local"
    CHECK_RESULT $? 0 0 "Local repo not enabled"
    yum clean all
    # git 已预装，直接 install 会变成空操作（且随后的 remove 会破坏环境），
    # 改为用 --resolve 下载做依赖闭包校验，同样能验证本地仓库元数据是否完整
    mkdir -p resolve_check
    yum --disablerepo="*" --enablerepo="local" download --resolve --destdir=resolve_check git
    CHECK_RESULT $? 0 0 "Package install fail"
    ls resolve_check | grep -q "git-core"
    CHECK_RESULT $? 0 0 "Dependency git-core not resolved from local repo"
    rm -rf resolve_check
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