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
# @Date      :   2024/02/23
# @License   :   Mulan PSL v2
# @Desc      :   test python3-wcwidth
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-wcwidth"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > test.py << EOF
# 用于计算字符宽度的Python库
from wcwidth import wcswidth

# 计算单个字符的宽度
char = '中'
width = wcswidth(char)
print(f"The width of the character '{char}' is {width} column(s)")

# 计算字符串的宽度
string = 'Hello, 世界!'
width = sum(wcswidth(c) for c in string)
print(f"The width of the string '{string}' is {width} column(s)")
EOF
  python3 test.py | grep -e "is 2 column(s)" -e "is 12 column(s)"
  CHECK_RESULT $? 0 0 "Failed to convert XML format to Python dictionary"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.py
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
