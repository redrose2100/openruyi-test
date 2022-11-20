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
# @Desc      :   verify the uasge of mc command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL mc
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat >1.txt <<EOL
 没有共产党
EOL

  cat >2.txt <<EOL
  就没有新中国
EOL
  mcedit --nosubshell 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit --nosubshell  failed"

  mcedit -l ./1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit -l  failed"

  mcedit --ftplog ./1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit --ftplog  failed"

  mcedit -v 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit -v  failed"

  mcedit --view 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit --view  failed"

  mcedit -e 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit -e  failed"

  mcedit --edit=1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcedit --edit  failed"

  rm -rf 1.txt 2.txt

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
