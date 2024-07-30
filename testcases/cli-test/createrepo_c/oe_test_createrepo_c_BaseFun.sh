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
# @Date      :   2024/07/30
# @License   :   Mulan PSL v2
# @Desc      :   test createrepo_c BaseFun
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
  createrepo_c -h |grep -Ei '用法|usage'
  CHECK_RESULT $? 0 0 "createrepo_c usage fail"

  createrepo_c -V
  CHECK_RESULT $? 0 0 "createrepo_c version fail"
  CHECK_RESULT "$(createrepo_c -V |awk '{print $2}')" "$(rpm -qi createrepo_c  |grep Version |awk '{print $NF}')" 0 "createrepo_c version fail"

  createrepo_c "${test_path}"/pkg -v
  CHECK_RESULT $? 0 0 "createrepo_c run verbosely fail"
  createrepo_c "${test_path}"/pkg -v 2>&1 |grep "$(date +%H:%M:%S)" |grep "All done"
  CHECK_RESULT $? 0 0 "createrepo_c run verbosely fail"

  createrepo_c --workers 4 "${test_path}"/pkg
  CHECK_RESULT $? 0 0 "fix Number of workers fail"
  CHECK_RESULT "$(createrepo_c --workers 4 "${test_path}"/pkg |grep "Pool started" |awk '{print $(NF-1)}')" "4" 0 "fix Number of workers fail"
  CHECK_RESULT "$(createrepo_c "${test_path}"/pkg |grep "Pool started" |awk '{print $(NF-1)}')" "5" 0 "default Number of workers error"
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


