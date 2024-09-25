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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/04/01
# @License   :   Mulan PSL v2
# @Desc      :   test numfmt
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL coreutils
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  numfmt --to=si 1000 |grep -i 1.0K
  CHECK_RESULT $? 0 0 "Error converting numbers to International System of Units"
  numfmt --to=iec 2048 |grep 2.0K
  CHECK_RESULT $? 0 0 "Error converting numbers to the International Electrotechnical Commission binary prefix unit system"
  numfmt --to=iec-i 4096 |grep 4.0Ki 
  CHECK_RESULT $? 0 0 "Convert numbers to the International Electrotechnical Commission's Binary Prefix System of Units (IEC) and report errors using binary units"
  echo 1K | numfmt --from=si |grep 1000 
  CHECK_RESULT $? 0 0 "Failed to read numbers from input and convert them to SI units"
  echo 1K | numfmt --from=iec |grep 1024 
  CHECK_RESULT $? 0 0 "Reading numbers from input and converting them to IEC units failed"
  df -B1 | numfmt --header --field 2-4 --to=si |grep tmpfs
  CHECK_RESULT $? 0 0 "Failed to convert numbers in file system information (using - B1 parameter in bytes) to SI units"
  find . -maxdepth 1 -type f -exec stat -c "%s %n" {} + | numfmt --header --field 1 --to=iec
  CHECK_RESULT $? 0 0 "Conversion of numbers in file size information (using - l parameter to display file information in long format) to IEC units failed"
  find . -maxdepth 1 -type f -exec stat -c "%s %n" {} + | numfmt --header --field 1 --from=iec --format %10f
  CHECK_RESULT $? 0 0 "Conversion to IEC units using the - lh parameter to display file information in both long format and human readable format failed while using the specified format"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
