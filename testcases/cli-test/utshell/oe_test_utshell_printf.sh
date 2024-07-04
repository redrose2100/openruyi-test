#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024.05.22
# @License   :   Mulan PSL v2
# @Desc      :   printf using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    useradd -m -s /bin/utshell test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > /home/test/test.sh <<EOF
#!/bin/utshell
returnSimple() {
  local  __resultvar=\$1
  printf -v "\$__resultvar" '%s' "ERROR"
  echo "Hello World"
}
returnSimple theResult
echo \${theResult}
echo Done.
EOF
    su - test -c "printf --help |grep -i printf"
    CHECK_RESULT $? 0 0 "Command execution failed"
    su - test -c 'printf "%-5s %-10s %-4.2f\n" 01 Tom 90.3456 |grep "90.35"'
    CHECK_RESULT $? 0 0 "Command execution failed"
    su - test -c "printf \"%b\" 'hello world\\n'"
    CHECK_RESULT $? 0 0 "Command execution failed"
    su - test -c "printf '%(%F %T %z%n)T'"
    CHECK_RESULT $? 0 0 "Command execution failed"
    su - test -c "bash test.sh |grep -E 'Hello|ERROR|Done.'"
    CHECK_RESULT $? 0 0 "Command execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"