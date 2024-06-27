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
# @Date      :   2024.5.28
# @License   :   Mulan PSL v2
# @Desc      :   Exit using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  OLD_LANG=$LANG
  export LANG=zh_CN.UTF-8
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "exit --help" 
  CHECK_RESULT $? 0 1 "exit --help fail"
  utshell -c  "touch test.sh"
  CHECK_RESULT $? 0 0 "touch fail"
  utshell -c cat >test.sh <<EOF
#!/bin/utshell
echo "before exit"
exit 8
echo "after exit"
EOF
  utshell -c 'utshell test.sh'
  CHECK_RESULT $? 8 0 "utshell test.sh fail"
  utshell test.sh;echo $?
  CHECK_RESULT $? 0 0 "echo fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  export LANG=${OLD_LANG}
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"