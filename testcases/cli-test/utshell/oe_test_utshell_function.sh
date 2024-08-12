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
# @Date      :   2024.8.12
# @License   :   Mulan PSL v2
# @Desc      :   function using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "help function"|grep -i "function"
  CHECK_RESULT $? 0 0 "help function fail"
  utshell -c cat >test.sh <<EOF
#!/bin/utshell
function test () {
echo -n  "your choice is"
}
echo "this program will print your selection!"
case \$1 in
"one")
test ; echo \$1 |tr 'a-z' 'A-Z'
;;
"two")
test ; echo \$1 |tr 'a-z' 'A-Z'
;;
"three")
test ; echo \$1  |tr 'a-z' 'A-Z'
;;
*)
echo "Usage \$0 ,please input {one|two|three}"
;;
esac
EOF
  utshell -c "utshell test.sh one"|grep -e "your choice isONE"
  CHECK_RESULT $? 0 0 "utshell test.sh one fail"
  utshell -c "utshell test.sh two"|grep -e "your choice isTWO"
  CHECK_RESULT $? 0 0 "utshell test.sh two fail"
  utshell -c "utshell test.sh three"|grep -e "your choice isTHREE"
  CHECK_RESULT $? 0 0 "utshell test.sh three fail"
  utshell -c "utshell test.sh ta1a1"|grep -e "Usage test.sh"
  CHECK_RESULT $? 0 0 "utshell test.sh ta1a1 fail"
  LOG_INFO "End of the test."
}
  
function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}
main "$@"