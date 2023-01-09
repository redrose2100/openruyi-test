# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of ttmkfdir command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ttmkfdir
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  ttmkfdir --max-missing-percentage 3
  CHECK_RESULT $? 0 0 "Check ttmkfdir --max-missing-percentage  failed"

  ttmkfdir -b 2
  CHECK_RESULT $? 0 0 "Check ttmkfdir -b  failed"

  ttmkfdir --additional-entries 2
  CHECK_RESULT $? 0 0 "Check ttmkfdir --additional-entries  failed"

  ttmkfdir -x 1
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -x failed"

  ttmkfdir --additional-entries 1
  CHECK_RESULT $? 0 0 "Check ttmkfdir  --additional-entries failed"

  ttmkfdir -c
  CHECK_RESULT $? 0 0 "Check ttmkfdir -c  failed"

  ttmkfdir --completeness
  CHECK_RESULT $? 0 0 "Check ttmkfdir --completeness  failed"

  ttmkfdir -p
  CHECK_RESULT $? 0 0 "Check ttmkfdir -p  failed"

  ttmkfdir --panose
  CHECK_RESULT $? 0 0 "Check ttmkfdir --panose  failed"

  ttmkfdir -h 2>&1 | grep 'This Program is (C) Joerg Pommnitz, 2000'
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -h failed"

  ttmkfdir --help 2>&1 | grep 'This Program is (C) Joerg Pommnitz, 2000'
  CHECK_RESULT $? 0 0 "Check ttmkfdir  --help failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
