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
# @Desc      :   verify the uasge of openjade command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."

  DNF_INSTALL openjade
  DNF_INSTALL git

  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  git clone https://gitee.com/src-openeuler/openjade.git
  cd openjade/
  tar -zxvf openjade-1.3.2.tar.gz
  cd openjade-1.3.2/testsuite

  sed -i '/.*JADE=..\/jade\/openjade*/c\JADE=\/usr\/bin\/openjade' Makefile
  sed -i '11s/.*/\tdiff $< .\//g' Makefile

  make
  CHECK_RESULT $? 0 0 "Check jade -c   failed"

  sed -i '/.*JADEX=$(JADE) -c ..\/dsssl\/catalog*/c\JADEX=$(JADE) -C ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -C  failed"

  sed -i '/.*JADEX=$(JADE) -C ..\/dsssl\/catalog*/c\JADEX=$(JADE) -b ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -b  failed"

  sed -i '/.*JADEX=$(JADE) -b ..\/dsssl\/catalog*/c\JADEX=$(JADE) -f ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -f  failed"

  sed -i '/.*JADEX=$(JADE) -f ..\/dsssl\/catalog*/c\JADEX=$(JADE) -e ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -e failed"

  sed -i '/.*JADEX=$(JADE) -e ..\/dsssl\/catalog*/c\JADEX=$(JADE) -v ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -v failed"

  sed -i '/.*JADEX=$(JADE) -v ..\/dsssl\/catalog*/c\JADEX=$(JADE) -D ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -D failed"

  sed -i '/.*JADEX=$(JADE) -D ..\/dsssl\/catalog*/c\JADEX=$(JADE) -R ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -R failed"

  sed -i '/.*JADEX=$(JADE) -R ..\/dsssl\/catalog*/c\JADEX=$(JADE) -a ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -a failed"

  sed -i '/.*JADEX=$(JADE) -a ..\/dsssl\/catalog*/c\JADEX=$(JADE) -A ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -A failed"

  sed -i '/.*JADEX=$(JADE) -A ..\/dsssl\/catalog*/c\JADEX=$(JADE) -E ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -E failed"

  sed -i '/.*JADEX=$(JADE) -E ..\/dsssl\/catalog*/c\JADEX=$(JADE) -e ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -e failed"

  sed -i '/.*JADEX=$(JADE) -e ..\/dsssl\/catalog*/c\JADEX=$(JADE) -g ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -g failed"

  sed -i '/.*JADEX=$(JADE) -g ..\/dsssl\/catalog*/c\JADEX=$(JADE) -n ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -n failed"

  sed -i '/.*JADEX=$(JADE) -n ..\/dsssl\/catalog*/c\JADEX=$(JADE) -x ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -x failed"

  sed -i '/.*JADEX=$(JADE) -x ..\/dsssl\/catalog*/c\JADEX=$(JADE) -i ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -i failed"

  sed -i '/.*JADEX=$(JADE) -i ..\/dsssl\/catalog*/c\JADEX=$(JADE) -w ..\/dsssl\/catalog' Makefile
  make
  CHECK_RESULT $? 0 0 "Check jade -w failed"

  openjade --help 2>&1 | grep 'Usage: openjade'
  CHECK_RESULT $? 0 0 "Check jade --help  failed"

  openjade -h 2>&1 | grep 'Usage: openjade'
  CHECK_RESULT $? 0 0 "Check jade -h  failed"

  rm -rf ../../../openjade
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_INSTALL
  LOG_INFO "Finish restoring the test environment."
}

main $@
