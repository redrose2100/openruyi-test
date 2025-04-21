#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/01/16
# @License   :   Mulan PSL v2
# @Desc      :   test augprint
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL augeas
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  augprint --lens=simplelines /etc/hosts
  CHECK_RESULT $? 0 0 "Simplelines camera failed to parse/etc/hosts file"
  augprint --regexp=12 /etc/hosts
  CHECK_RESULT $? 0 0 "Find and output the content or node error that matches regular expression 12 in the/etc/hosts file"
  augprint --pretty /etc/hosts 
  CHECK_RESULT $? 0 0 "The generated output command script will have a more readable format for error reporting"
  augprint --noseq /etc/hosts
  CHECK_RESULT $? 0 0 "Using * instead of seq:: * in path expression yields an error message"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

