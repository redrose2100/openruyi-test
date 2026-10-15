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
# @Author    :   jingxiaohui
# @Contact   :   jingxiaohui@uniontech.com
# @Date      :   2024.6.19
# @License   :   Mulan PSL v2
# @Desc      :   select using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "help select"|grep -i select
  CHECK_RESULT $? 0 0 "help select fail"
  utshell -c "touch test.sh"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  utshell -c cat >test.sh<<EOF
#! /bin/utshell
select name in ywx kaka king
do
echo \$name
done
EOF
  (utshell -c "utshell test.sh"<<EOF
1
2
3
EOF
)> a.sh 
  CHECK_RESULT $? 1 0 "utshell test.sh fail"
  utshell -c "cat a.sh | grep -e king"
  CHECK_RESULT $? 0 0 "grep fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  rm -rf a.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
