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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2023/11/21
# @License   :   Mulan PSL v2
# @Desc      :   test  newusers
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > /home/users.txt <<EOF
test1:R0ck92020:1001:1001:System User 1:/home/test1:/bin/bash
test2:R0ck92020:1002:1001:System User 2:/home/test2:/bin/bash
EOF
  CHECK_RESULT $? 0 0 "Finish preparing the test environment."
  newusers /home/users.txt
  CHECK_RESULT $? 0 0 "User creation failed"
  id test1 test2
  CHECK_RESULT $? 0 0 "Check failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  userdel -r test1 test2
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
