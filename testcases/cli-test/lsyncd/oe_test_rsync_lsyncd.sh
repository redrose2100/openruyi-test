#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhaorunqi
# @Contact   :   runqi@isrc.iscas.ac.cn
# @Date      :   2022/1/15
# @License   :   Mulan PSL v2
# @Desc      :   Test lsyncd -rsync
# #############################################

source "../common/common_lib.sh"

function config_params() {
  LOG_INFO "Start to config params of the case."
  mkdir $OET_PATH/testcases/cli-test/lsyncd/source_dir
  mkdir $OET_PATH/testcases/cli-test/lsyncd/target_dir
  mkdir /var/log/lsyncd
  mkdir /etc/lsyncd
  echo "settings {
  logfile = "\"/var/log/lsyncd/lsyncd.log"\",
	statusFile = "\"/var/log/lsyncd/lsyncd.status"\"
}
sync {
	default.rsync,
	source = "\"$OET_PATH/testcases/cli-test/lsyncd/source_dir/"\",
	target = "\"$OET_PATH/testcases/cli-test/lsyncd/target_dir/"\",
	delete = true,
	delay = 0,
	exclude={
	  "\".txt"\"
	},
	rsync = {
	binary = "\"/usr/bin/rsync"\",
	archive = true,
  compress = true,
  verbose = true,
	owner = true,
  perms = true,
  _extra = {"\"--bwlimit=2000"\"},
  }
}" >>/etc/lsyncd.conf
  echo "This is a test for rsync" >>$OET_PATH/testcases/cli-test/lsyncd/source_dir/test.lua
  LOG_INFO "End to config params of the case."
}

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL lsyncd
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  /usr/bin/lsyncd /etc/lsyncd.conf
  SLEEP_WAIT 5
  CHECK_RESULT "$(ls -l $OET_PATH/testcases/cli-test/lsyncd/target_dir/ |grep '^-' | wc -l)" 1
  LOG_INFO "End to run test."
}
function post_test() {
  LOG_INFO "Start to restore the test environment."
  DNF_REMOVE lsyncd
  rm -rf $OET_PATH/testcases/cli-test/lsyncd/source_dir
  rm -rf $OET_PATH/testcases/cli-test/lsyncd/target_dir
  rm -rf /var/log/lsyncd
  rm -rf /etc/lsyncd
  rm -rf /etc/lsyncd.conf
  LOG_INFO "End to restore the test environment."
}

main "$@"
