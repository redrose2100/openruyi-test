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
# @Date      :   2024.6.4
# @License   :   Mulan PSL v2
# @Desc      :   umask using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "umask --help"|grep -i umask
  CHECK_RESULT $? 0 0 "umask --help fail"
  utshell -c "umask"|grep 0022
  CHECK_RESULT $? 0 0 "umask fail"
  utshell -c "umask -p"|grep "umask 0022"
  CHECK_RESULT $? 0 0 "umask -p fail"
  utshell -c "umask -S"|grep "u=rwx,g=rx,o=rx"
  CHECK_RESULT $? 0 0 "umask -S fail"
  utshell -c "umask 0044"
  CHECK_RESULT $? 0 0 "umask 0044 fail"
  utshell -c "umask 0044;umask -p"|grep "umask 0044"
  CHECK_RESULT $? 0 0 "umask -p fail"
  utshell -c "umask 0044;umask -S"|grep "u=rwx,g=wx,o=wx"
  CHECK_RESULT $? 0 0 "umask -S fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  utshell -c "umask 0022"
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"