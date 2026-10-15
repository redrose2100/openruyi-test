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
# @Date      :   2024.6.3
# @License   :   Mulan PSL v2
# @Desc      :   until using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "help until"|grep -i until
  CHECK_RESULT $? 0 0 "echo fail"
  utshell -c "touch test.sh"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  utshell -c cat >test.sh <<EOF
#!/bin/utshell
i=1
sum=0
until ((i > 100))
do
((sum += i))
((i++))
done
echo "The sum is: \$sum"
EOF
  utshell -c "utshell test.sh"|grep 5050
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"