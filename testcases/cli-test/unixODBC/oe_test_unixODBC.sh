#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/05/23
# @License   :   Mulan PSL v2
# @Desc      :   test  unixODBC
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL unixODBC
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  odbc_config --cflags |grep "usr" 
  CHECK_RESULT $? 0 0 "Failed to obtain help command"
  odbc_config --version | grep "$(rpm -q unixODBC | awk -F '-' '{print $4}')"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  odbc_config --ulen |grep "SQLULEN"
  CHECK_RESULT $? 0 0 "Error printing prefix path for libogdi"
  odbc_config --header |grep "UNICODE"
  CHECK_RESULT $? 0 0 "Error printing directory path containing library files"
  odbc_config --libs |grep "lib64"
  CHECK_RESULT $? 0 0 "Error printing preprocessor flags, I_opts, and compiler options"
  odbcinst -j | grep -q "unixODBC"
  CHECK_RESULT $? 0 0 "odbcinst tool validation failed"
  odbcinst -q -d | grep -i "mysql"
  CHECK_RESULT $? 0 0 "mysql driver not found"
  odbcinst -q -d -n "MySql" | grep -i "mysql"
  CHECK_RESULT $? 0 0 "mysql odbc driver not detected"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

