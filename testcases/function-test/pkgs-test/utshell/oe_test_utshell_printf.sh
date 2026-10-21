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
# @Date      :   2024.7.4
# @License   :   Mulan PSL v2
# @Desc      :   printf using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "printf --help"|grep -i printf
  CHECK_RESULT $? 0 0 "printf --help fail"
  utshell -c "printf \"%-5s %-10s %-4.2f\n\" 01 Tom 90.3456"|grep "Tom"
  CHECK_RESULT $? 0 0 "print Tom fail"
  utshell -c "printf \"%b\" 'hello world\n'"|grep "hello world"
  CHECK_RESULT $? 0 0 "printf 'hello world fail"
  utshell -c "printf '%q\n' 'a b c'"|grep "a\\\\ b\\\\ c"
  CHECK_RESULT $? 0 0 "printf 'a b c' fail"
  utshell -c "printf \"%(%F %T %z%n)T\""|grep +0800
  CHECK_RESULT $? 0 0 "printf fail"
  cat >t1.sh <<EOF
#!/bin/utshells
returnSimple() {
local  __resultvar=\$1
printf -v "\$__resultvar" '%s' "ERROR"
echo "Hello World"
}
returnSimple theResult
echo \${theResult}
echo Done.
EOF
  utshell t1.sh | grep -E "Hello World|ERROR|Done"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf t1.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"