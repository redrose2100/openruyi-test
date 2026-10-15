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
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2024.7.15
# @License   :   Mulan PSL v2
# @Desc      :   mapfile using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  useradd -m -s /bin/utshell test
  su - test -c "echo \$0" |grep -i utshell
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  su - test -c 'echo {a..z} | tr " " "\n" >alpha.log'
  test -f /home/test/alpha.log
  CHECK_RESULT $? 0 0 "File generation failed"
  su - test -c "mapfile myarr <alpha.log && echo \${myarr[@]}" |grep '^a.*z$'
  CHECK_RESULT $? 0 0 "Incorrect array reading"
  su - test -c "mapfile -n 6 myarr <alpha.log && echo \${myarr[@]}" | grep '^a.*f$'
  CHECK_RESULT $? 0 0 "Failed to display the first 6 letters"
  su - test -c "mapfile -s 10 myarr <alpha.log && echo \${myarr[@]}" |grep '^k.*z$'
  CHECK_RESULT $? 0 0 "Failed to display the last 16 letters"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  userdel -rf test
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
