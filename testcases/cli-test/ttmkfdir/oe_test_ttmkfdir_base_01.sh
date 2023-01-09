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

  ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir
  CHECK_RESULT $? 0 0 "Check ttmkfdir -e  failed"

  ttmkfdir --encoding /usr/share/X11/fonts/encodings/encodings.dir
  CHECK_RESULT $? 0 0 "Check ttmkfdir -e  failed"

  ttmkfdir -o 'fonts.scale'
  CHECK_RESULT $? 0 0 "Check ttmkfdir -o  failed"

  ttmkfdir --output 'fonts.scale'
  CHECK_RESULT $? 0 0 "Check ttmkfdir --output  failed"

  ttmkfdir -d '.'
  CHECK_RESULT $? 0 0 "Check ttmkfdir -d  failed"

  ttmkfdir --font-dir '.'
  CHECK_RESULT $? 0 0 "Check ttmkfdir --font-dir  failed"

  ttmkfdir -f 'misc'
  CHECK_RESULT $? 0 0 "Check ttmkfdir -f  failed"

  ttmkfdir --default-foundry 'misc'
  CHECK_RESULT $? 0 0 "Check ttmkfdir --default-foundry  failed"

  ttmkfdir -m 4
  CHECK_RESULT $? 0 0 "Check ttmkfdir -m  failed"

  ttmkfdir --max-missing 4
  CHECK_RESULT $? 0 0 "Check ttmkfdir --max-missing  failed"

  ttmkfdir -a 3
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -a failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
