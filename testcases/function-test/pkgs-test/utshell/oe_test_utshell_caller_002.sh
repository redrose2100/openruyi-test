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
# @Author    :   liangjiayu01
# @Contact   :   liangjiayu@uniontech.com
# @Date      :   2024.07.04
# @License   :   Mulan PSL v2
# @Desc      :   utshell caller_002 test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "caller --help | grep filename"
  CHECK_RESULT $? 0 0 "caller --help fail"
cat >test000.sh <<EOF
#!/bin/bash
test1() {
for ((i=0;i<10;i++))
do
   echo "$i"
done
caller 0
}

test2() {
i=1
while [ $i -le 10 ]
do
    echo $i
    let i++
done
caller 0
}

test2
test1
EOF
  utshell -c "sh test000.sh | grep -E '20'"
  CHECK_RESULT $? 0 0 "test caller fail"
  utshell -c "sh test000.sh | grep -E '21'"
  CHECK_RESULT $? 0 0 "test caller fail"
  utshell -c "sh test000.sh | grep main"
  CHECK_RESULT $? 0 0 "test caller fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test000.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup."
}

main "$@"
