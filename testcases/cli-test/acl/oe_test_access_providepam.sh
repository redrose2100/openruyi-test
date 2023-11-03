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
# @Desc      :   test accesscontrol-providepam
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
  LOG_INFO "Start to run test."
  rpm -qa|grep pam
  CHECK_RESULT $? 0 0 "pam not exist"
  test -e  /usr/lib64/security/pam_systemd.so
  CHECK_RESULT $? 0 0 "pam_systemd.so not exist"
  LOG_INFO "End of the test"
}

main "$@"
