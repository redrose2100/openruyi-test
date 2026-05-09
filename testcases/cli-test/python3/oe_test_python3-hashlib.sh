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
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024/03/07
# @License   :   Mulan PSL v2
# @Desc      :   File system common command python3-hashlib
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
  LOG_INFO "Start to run test."
  python3 common/test_python3-hashlib.py | grep "Test Passed"
  CHECK_RESULT $? 0 0 "python3-hashlib test fail"
  LOG_INFO "End of the test."
}

main "$@"
