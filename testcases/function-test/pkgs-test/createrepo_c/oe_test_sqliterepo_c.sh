#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2024/08/21
# @License   :   Mulan PSL v2
# @Desc      :   test sqliterepo_c
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "createrepo_c"
  yum download tcpdump
  test -f /etc/yum.repos.d/local.repo && rm -rf /etc/yum.repos.d/local.repo
  test_path="/tmp"
  test -d "${test_path}"/pkg && rm -rf "${test_path}"/pkg
  mkdir "${test_path}"/pkg
  cat > /etc/yum.repos.d/local.repo << EOF
[local]
name=local
baseurl=file://${test_path}/pkg
enabled=1
gpgcheck=0
EOF
  mv tcpdump* "${test_path}"/pkg
  yum clean all
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  sqliterepo_c -h |grep -Ei '用法|usage'
  CHECK_RESULT $? 0 0 "sqliterepo_c usage fail"

  sqliterepo_c -V
  CHECK_RESULT $? 0 0 "sqliterepo_c version fail"
  CHECK_RESULT "$(sqliterepo_c -V |awk '{print $2}')" "$(rpm -qi createrepo_c  |grep Version |awk '{print $NF}')" 0 "sqliterepo_c version fail"

  createrepo_c "${test_path}"/pkg
  CHECK_RESULT $? 0 0 "createrepo fail"
  grep sqlite "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 1 "createrepo default no database fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite*
  CHECK_RESULT $? 0 1 "createrepo default no database fail"

  createrepo_c -d "${test_path}"/pkg |grep "Preparing sqlite DBs"
  CHECK_RESULT $? 0 0 "createrepo create database fail"
  grep sqlite.bz2 "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 0 "default sqlite format check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.bz2
  CHECK_RESULT $? 0 0 "default sqlite format check fail"

  createrepo_c -d --xz "${test_path}"/pkg |grep "Preparing sqlite DBs"
  CHECK_RESULT $? 0 0 "createrepo create database fail"
  grep sqlite.xz "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.xz
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  grep sqlite.bz2 "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 1 "sqlite format bz2 check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.bz2
  CHECK_RESULT $? 0 1 "sqlite format bz2 check fail"

  sqliterepo_c "${test_path}"/pkg
  CHECK_RESULT $? 0 1 "repeat create database fail"
  sqliterepo_c "${test_path}"/pkg  --keep-old --force
  CHECK_RESULT $? 0 0 "repeat create database force fail"
  grep sqlite.xz "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 1 "sqlite format xz check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.xz
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  grep sqlite.bz2 "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 0 "sqlite format bz2 check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.bz2
  CHECK_RESULT $? 0 0 "sqlite format bz2 check fail"

  CHECK_RESULT "$(sqliterepo_c  "${test_path}"/pkg  --force)" "Preparing sqlite DBs" 0 "default create sqlite quiet fail"
  CHECK_RESULT "$(sqliterepo_c  "${test_path}"/pkg  --force -q)" "Preparing sqlite DBs" 0 "create sqlite quiet fail"
  sqliterepo_c  "${test_path}"/pkg  --force -v 2>&1 |grep "$(date +%H:%M:%S)"
  CHECK_RESULT $? 0 0 "create sqlite verbose fail"
  grep sqlite.bz2 "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 0 "default sqlite format check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.bz2
  CHECK_RESULT $? 0 0 "default sqlite format check fail"
  grep sqlite.xz "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 1 "default sqlite format check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.xz
  CHECK_RESULT $? 0 0 "default sqlite format check fail"

  sqliterepo_c "${test_path}"/pkg --xz --force
  CHECK_RESULT $? 0 0 "create database xz format fail"
  grep sqlite.bz2 "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 1 "sqlite format xz check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.bz2
  CHECK_RESULT $? 0 1 "sqlite format xz check fail"
  grep sqlite.xz "${test_path}"/pkg/repodata/repomd.xml
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  ls -l "${test_path}"/pkg/repodata/*sqlite.xz
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  test -f /etc/yum.repos.d/local.repo && rm -rf /etc/yum.repos.d/local.repo
  test -d "${test_path}"/pkg && rm -rf "${test_path}"/pkg
  yum clean all
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

