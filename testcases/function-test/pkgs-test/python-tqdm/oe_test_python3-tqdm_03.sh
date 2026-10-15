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
# @Desc      :   test python3-tqdm: Use a progress bar in a nested loop
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-tqdm"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > test.py << EOF
# 外部循环的进度条是 "Outer Loop"，内部循环的进度条是 "Inner Loop"，leave=False 参数用于保持外部循环的进度条不被覆盖。
from tqdm import tqdm
import time

# 嵌套循环中的进度条
for i in tqdm(range(5), desc='Outer Loop'):
    for j in tqdm(range(10), desc='Inner Loop', leave=False):
        time.sleep(0.1)
EOF
  python3  test.py
  CHECK_RESULT $? 0 0 "Failed to use the progress bar in a nested loop"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.py
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
