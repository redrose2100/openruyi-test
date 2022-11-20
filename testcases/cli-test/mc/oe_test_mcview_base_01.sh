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

# 测试对象、测试需要的工具等安装准备
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

  mcview -V 2>&1 | grep 'GNU Midnight Commander'
  CHECK_RESULT $? 0 0 "Check mcview -V failed"

  mcview --version 2>&1 | grep 'GNU Midnight Commander '
  CHECK_RESULT $? 0 0 "Check mcview --version failed"

  mcview -F 2>&1 | grep 'Home路径' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview -F failed"

  mcview --datadir-info 2>&1 | grep 'Home' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview --datadir-info failed"

  mcview --configure-options 2>&1 | grep "'--build=" >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview --configure-options failed"

  mcview -P 1.txt 2.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview -P failed"

  mcview --printwd=1.txt 2.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview --printwd failed"

  mcview -U 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview -U failed"

  mcview --subshell 1.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview --subshell failed"

  mcview -u 1.txt 2.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mcview -u failed"
  rm -rf 1.txt 2.txt

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
