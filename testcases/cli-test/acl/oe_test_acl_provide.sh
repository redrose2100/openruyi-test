#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   test acl-provide
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
  LOG_INFO "Start to run test."
  rpm -qa |grep acl
  CHECK_RESULT $? 0 0 "step1 failure"
  which chacl
  CHECK_RESULT $? 0 0 "chacl not exist"
  which getfacl
  CHECK_RESULT $? 0 0 "getfacl not exist"
  which setfacl
  CHECK_RESULT $? 0 0 "setfacl not exist"
  chacl --help 2>&1 | grep "Usage"
  CHECK_RESULT $? 0 0 "chacl is enable"
  getfacl --help 2>&1 | grep "Usage"
  CHECK_RESULT $? 0 0 "getfacl is enable"
  setfacl --help 2>&1 | grep "Usage"
  CHECK_RESULT $? 0 0 "setfacl is enable"
  LOG_INFO "End of the test."
}

main "$@"
