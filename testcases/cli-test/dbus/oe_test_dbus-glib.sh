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
# @Date      :   2025/05/08
# @License   :   Mulan PSL v2
# @Desc      :   test dbus-glib
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL dbus-glib dbus-glib-devel
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  dbus-binding-tool --mode=glib-server --prefix=my_dbus_service --output=my_dbus_service-generated.c common/my_dbus_service.xml 
  CHECK_RESULT $? 0 0 "Generate GLib server-side code error"
  dbus-binding-tool --mode=glib-client --prefix=my_dbus_client --output=my_dbus_client-generated.c common/my_dbus_interface.xml
  CHECK_RESULT $? 0 0 "Generate GLib client code error"
  dbus-binding-tool --mode=pretty common/my_dbus_interface.xml
  CHECK_RESULT $? 0 0 "Generate readable text output error"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf my_dbus_client-generated.c my_dbus_service-generated.c 
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

