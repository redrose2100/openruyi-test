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
# @Contact   :   geyaning@uniontech
# @Date      :   2023/05/22
# @License   :   Mulan PSL v2
# @Desc      :   xinetd Basic functions
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "xinetd net-tools"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start testing..."
  cat >>/etc/xinetd.d/rsync <<EOF
service rsync
{
disable = no
socket_type = stream
wait = no
user = root
server = /usr/bin/rsync
server_args = --daemon
log_on_failure += USERID
cps = 100 2
}
EOF
  systemctl daemon-reload
  systemctl restart xinetd
  CHECK_RESULT $? 0 0 "xinetd.service restart failed"
  systemctl status xinetd.service | grep "Active: active"
  CHECK_RESULT $? 0 0 "xinetd Listening port error"
  systemctl stop xinetd
  CHECK_RESULT $? 0 0 "xinetd.service stop failed"
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf /etc/xinetd.d/rsync
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
