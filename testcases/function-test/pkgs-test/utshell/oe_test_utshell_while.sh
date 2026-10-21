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
  export LANG=en_US.UTF-8
  utshell -c "help while" |grep while
  CHECK_RESULT $? 0 0 "help while fail"

  cat >test.sh <<EOF
#!/bin/utshell
varl=5
while [ \$varl -gt 0 ]
do
echo \$varl
varl=\$((varl-1))
done
EOF
  utshell test.sh | grep -E "1|2|3|4|5"
  CHECK_RESULT $? 0 0 "test.sh fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.sh
  LOG_INFO "Finish environment cleanup!"
}

main "$@"