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
# @Date      :   2024.6.5
# @License   :   Mulan PSL v2
# @Desc      :   If using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "help if"|grep -i if 
  CHECK_RESULT $? 0 0 "help if fail"
  utshell -c "touch test.sh"
  utshell -c cat >test.sh <<EOF 
#!/bin/utshell
if [[ \$1 >  5 ]];then
echo "\$1的值大于5"
elif [[ \$1 == 5 ]];then
echo "\$1的值等于5"
else
echo "\$1的值小于5"
fi
EOF
  utshell -c "utshell test.sh 5"|grep "5的值等于5"
  CHECK_RESULT $? 0 0 "utshell test.sh 5 fail"
  utshell -c "utshell test.sh 6"|grep "6的值大于5"
  CHECK_RESULT $? 0 0 "utshell test.sh 6 fail"
  utshell -c "utshell test.sh 3"|grep "3的值小于5"
  CHECK_RESULT $? 0 0 "utshell test.sh 3 fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}
main "$@"