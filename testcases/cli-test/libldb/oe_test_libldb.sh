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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   test libldb
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "openldap-servers openldap-clients"
  systemctl enable slapd && systemctl start slapd
  mkdir /tmp/test
  cat > /tmp/test/chrootpw.ldif << EOF
# specify the password generated above for "olcRootPW" section
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}E2L9nvHzas+TYf3PW4KQmn7VyveLehqP
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cd /tmp/test && ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif 2>&1 | grep "SASL/EXTERNAL authentication started"
  CHECK_RESULT $? 0 0 "ldapadd failure"
  cd /tmp/test && ldapsearch -x -b "dc=zhizhangyi,dc=com" -H ldap://127.0.0.1 2>&1 | grep "result"
  CHECK_RESULT $? 0 0 "ldapsearch failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf /tmp/test
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
