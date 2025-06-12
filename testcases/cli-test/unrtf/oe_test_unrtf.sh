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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2024/03/13
# @License   :   Mulan PSL v2
# @Desc      :   Rich Text Format
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "unrtf"
  mkdir /tmp/test
  cd /tmp/test || exit
  echo "test" > input.rtf
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  unrtf --html input.rtf > output.html
  test -f output.html
  CHECK_RESULT $? 0 0 "output.html not exist"
  grep "test" output.html
  CHECK_RESULT $? 0 0 "The output.html content is not accurate"
  unrtf --latex input.rtf > output.tex
  test -f output.tex
  CHECK_RESULT $? 0 0 "output.tex not exist"
  grep "end" output.tex
  unrtf --text input.rtf > output.txt
  test -f output.txt
  CHECK_RESULT $? 0 0 "output.txt not exist"
  unrtf --html input.txt > output.rtf
  test -f output.rtf
  CHECK_RESULT $? 0 0 "output.rtf not exist"
  unrtf --noremap input.rtf  | grep test
  CHECK_RESULT $? 0 0 "the retrieval of test failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf /tmp/test
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
