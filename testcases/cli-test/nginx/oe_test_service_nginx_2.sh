#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/08/25
# @License   :   Mulan PSL v2
# @Desc      :   Concurrent access test
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "nginx httpd-tools"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start testing..."
  systemctl start nginx
  CHECK_RESULT $? 0 0 "nginx cannot start"
  curl localhost | grep "<strong>nginx</strong>"
  CHECK_RESULT $? 0 0 "nginx cannot be accessed"
  ab -n 500000 -c 500 http://localhost:80/ | grep "Complete requests:      500000"
  CHECK_RESULT $? 0 0 "Failed to reach the specified total number of visits"
  LOG_INFO "Finish test!"
}

function post_test() {
  LOG_INFO "start environment cleanup."
  systemctl stop nginx.service
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
