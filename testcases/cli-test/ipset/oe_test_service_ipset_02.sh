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
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/04/13
# @License   :   Mulan PSL v2
# @Desc      :   test flac
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ipset
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ipset create blacklist hash:net maxelem 1000000
  ipset add blacklist 10.7.10.10
  ipset save blacklist -f blacklist.txt
  CHECK_RESULT $? 0 0 "save failure"
  ipset destroy blacklist
  ipset list 2>&1 |grep "blacklist"
  CHECK_RESULT $? 0 1 "destory failure"
  ipset restore -f blacklist.txt
  ipset list 2>&1 |grep "blacklist"
  CHECK_RESULT $? 0 0 "restory failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE ipset
  rm -rf blacklist.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
