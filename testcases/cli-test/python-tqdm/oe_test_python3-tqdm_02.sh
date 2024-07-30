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
# @Date      :   2024/02/22
# @License   :   Mulan PSL v2
# @Desc      :   test python3-tqdm: Customize the description and style of the progress bar
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-tqdm"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat >test.py <<EOF
# 通过 desc 参数指定了进度条的描述为 "Processing"，并通过 bar_format 参数自定义了进度条的样式。
from tqdm import tqdm
import time

# 自定义进度条的描述和样式
for i in tqdm(range(10), desc='Processing', bar_format='{desc}: {percentage:3.0f}% {bar}'):
    time.sleep(0.5)
EOF
  python3 test.py
  CHECK_RESULT $? 0 0 "Wrapping the object to be iterated with the tqdm iterator failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.py
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
