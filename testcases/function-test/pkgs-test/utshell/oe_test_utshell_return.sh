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
# @Date      :   2024.6.6
# @License   :   Mulan PSL v2
# @Desc      :   Return using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "return --help"|grep -i return 
  CHECK_RESULT $? 0 0 "return --help fail"
  utshell -c "touch test.sh"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  utshell -c cat >test.sh<<EOF
#!/bin/utshell
example(){
return 9
}
example
EOF
  utshell -c "utshell test.sh"
  CHECK_RESULT $? 9 0 "utshell test.sh fail"
  utshell -c "utshell test.sh;echo \$?"|grep 9
  CHECK_RESULT $? 0 0 "utshell test.sh ;echo \$? fail"
  utshell -c "touch test2.sh"
  CHECK_RESULT $? 0 0 "touch test2.sh fail"
  utshell -c cat >test2.sh<<EOF
#!/bin/utshell
example(){
return 259
}
example
EOF
  utshell -c "utshell test2.sh"
  CHECK_RESULT $? 3 0 "utshell test.sh fail"
  utshell -c "utshell test2.sh;echo \$?"|grep 3
  CHECK_RESULT $? 0 0 "utshell test2.sh ;echo \$? fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  rm -rf test2.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"