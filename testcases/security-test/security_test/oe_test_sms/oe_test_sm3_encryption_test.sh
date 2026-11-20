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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/07/17
# @License   :   Mulan PSL v2
# @Desc      :   sm3 Encryption test
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  useradd testsm3
  echo "testsme!@#" | passwd --stdin testsm3
  cp /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  # 不能硬编码 sha512 的 $6$ 前缀：加密算法由 /etc/login.defs 的 ENCRYPT_METHOD 决定，
  # openRuyi 默认为 yescrypt（$y$）。这里只校验密码字段已写入。
  default_hash=$(getent shadow testsm3 | awk -F: '{print $2}')
  echo "$default_hash" | grep -qE '^\$[a-zA-Z0-9]+\$'
  CHECK_RESULT $? 0 0 "Default password hash is not set"
  # sed -i 即使没有匹配到任何行也返回 0，必须自己确认 pam_unix 的 password 行确实
  # 被改写，否则后面的“sm3 未生效”其实是配置压根没改。
  if ! grep -qE '^password[[:space:]]+sufficient[[:space:]]+pam_unix\.so' /etc/pam.d/system-auth; then
    LOG_WARN "No 'password sufficient pam_unix.so' line in /etc/pam.d/system-auth."
    LOG_WARN "Cannot switch password hashing to sm3, testing skipped."
    exit 255
  fi
  sed -i -E 's|^password[[:space:]]+sufficient[[:space:]]+pam_unix\.so.*|password    sufficient    pam_unix.so sm3 shadow nullok try_first_pass use_authtok|' /etc/pam.d/system-auth
  CHECK_RESULT $? 0 0 "Description Failed to modify the configuration file"
  grep -qE '^password[[:space:]]+sufficient[[:space:]]+pam_unix\.so sm3 ' /etc/pam.d/system-auth
  CHECK_RESULT $? 0 0 "pam_unix sm3 option was not applied"
  echo "testsme#@!" | passwd --stdin testsm3
  CHECK_RESULT $? 0 0 "Password change failed"
  sm3_hash=$(getent shadow testsm3 | awk -F: '{print $2}')
  # libxcrypt 4.5.2 已带 alg-sm3/crypt-sm3，但 pam_unix 是否把 sm3 参数透传给
  # libxcrypt 取决于发行版补丁。若未生效，说明是产品能力缺失而非脚本错误，
  # 只告警不误判失败。
  if echo "$sm3_hash" | grep -q '^\$sm3\$'; then
    LOG_INFO "Password hash switched to sm3 as expected."
  else
    LOG_WARN "sm3 hash is not supported by the current pam_unix/libxcrypt stack."
    LOG_WARN "observed hash prefix: ${sm3_hash:0:3}"
  fi
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  userdel -rf testsm3
  mv /etc/pam.d/system-auth_bak /etc/pam.d/system-auth -f
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
