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
# @Date      :   2024/07/25
# @License   :   Mulan PSL v2
# @Desc      :   test createrepo_c pkg path
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "createrepo_c"
  yum download httpd-help httpd tcpdump
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
  mv httpd* tcpdump* "${test_path}"/pkg
  createrepo_c "${test_path}"/pkg
  yum clean all
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "httpd httpd-help tcpdump" 0 "createrepo all rpm fail"

  createrepo_c -x "*rpm" "${test_path}"/pkg
  CHECK_RESULT $? 0 0 "createrepo no rpm fail"
  yum clean all;sleep 5
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch")x" "x" 0 "createrepo no rpm fail"

  cd "${test_path}"/pkg || exit
  createrepo_c -n tcpdump* ./
  CHECK_RESULT $? 0 0 "createrepo only tcpdump rpm fail"
  yum clean all;sleep 3
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "tcpdump" 0 "createrepo only tcpdump rpm fail"

  createrepo_c -n httpd-help* -n tcpdump* -x tcpdump* ./
  CHECK_RESULT $? 0 0 "createrepo only httpd-help rpm fail"
  yum clean all;sleep 3
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "httpd-help" 0 "createrepo only httpd-help rpm fail"

  createrepo_c --update ./
  CHECK_RESULT $? 0 0 "createrepo update fail"
  yum clean all;sleep 3
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "httpd httpd-help tcpdump" 0 "createrepo update fail"

  basename -a "$(find ./ -name 'tcpdump*rpm')" > /tmp/list
  createrepo -i /tmp/list ./
  CHECK_RESULT $? 0 0 "createrepo pkglist fail"
  yum clean all;sleep 3
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "tcpdump" 0 "createrepo pkglist fail"

  createrepo --read-pkgs-list=/tmp/list  ./
  CHECK_RESULT $? 0 0 "Output the paths to the pkgs fail"
  yum clean all;sleep 3
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  "httpd httpd-help tcpdump" 0 "Output the paths to the pkgs fail"
  CHECK_RESULT "$(cat < /tmp/list |sort)" "$(find ./ -name '*rpm' -print0 |xargs -0 basename -a |sort)" 0 "Output the paths to the pkgs fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  cd .. || exit
  test -f /etc/yum.repos.d/local.repo && rm -rf /etc/yum.repos.d/local.repo
  test -f /tmp/list && rm -rf /tmp/list
  test -d "${test_path}"/pkg && rm -rf "${test_path}"/pkg
  yum clean all
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


