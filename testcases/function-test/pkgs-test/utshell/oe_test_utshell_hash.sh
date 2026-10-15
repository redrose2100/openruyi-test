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
# @Author    :   mataotao
# @Contact   :   mataotao@uniontech.com
# @Date      :   2024/05/31
# @License   :   Mulan PSL v2
# @Desc      :   utshell-test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "hash -p /bin/ls  bb;bb /"| grep "home"
  CHECK_RESULT $? 0 0 "hash -p /bin/ls test fail"
  cat >test.txt <<EOF
123456
EOF
  utshell -c "hash -p /bin/cat aa;aa test.txt"| grep 123456
  CHECK_RESULT $? 0 0 "hash -p /bin/cat test fail"
  utshell -c "hash -p /bin/cat aa;hash -p /bin/ls bb;hash -l" | grep -E "aa|bb"
  CHECK_RESULT $? 0 0 "hash -l test fail"
  utshell -c "hash -p /bin/cat aa;hash -t aa" | grep "cat"
  CHECK_RESULT $? 0 0 "hash -l test fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"