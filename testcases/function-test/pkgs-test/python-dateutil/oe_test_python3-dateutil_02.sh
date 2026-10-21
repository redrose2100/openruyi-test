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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2024/02/24
# @License   :   Mulan PSL v2
# @Desc      :   test python3-dateutil
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-dateutil"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > date.py << EOF
from dateutil.relativedelta import relativedelta
from datetime import datetime

# 计算日期差
current_date = datetime(2024, 1, 1, 0, 0)
future_date = current_date + relativedelta(months=2, days=25)
date_diff = future_date - current_date
print("Future Date:", future_date)
print("Date Difference:", date_diff)
EOF
  python3 date.py |grep "85 days"
  CHECK_RESULT $? 0 0 "command fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.py
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
