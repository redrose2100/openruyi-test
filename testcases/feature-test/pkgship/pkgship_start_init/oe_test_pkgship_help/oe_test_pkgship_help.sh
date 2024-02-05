#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2020-08-28
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function run_test() {
  LOG_INFO "Start to run test."

  pkgship -h | grep "usage: pkgship \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship is error."

  pkgship init -h | grep "usage: pkgship init \[-h\] \[-filepath FILEPATH\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship init is error."

  pkgship list -h | grep "usage: pkgship list \[-h\] \[-packagename PACKAGENAME\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship list is error."

  pkgship pkginfo -h | grep "usage: pkgship pkginfo \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship pkginfo is error."

  pkgship builddep -h | grep "usage: pkgship builddep \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship buildep is error."

  pkgship installdep -h | grep "usage: pkgship installdep \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship installdep is error."

  pkgship selfdepend -h | grep "usage: pkgship selfdepend \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship selfdepend is error."

  pkgship bedepend -h | grep "usage: pkgship bedepend \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship bedpend is error."

  pkgship dbs -h | grep "usage: pkgship dbs \[-h\]" >/dev/null
  CHECK_RESULT $? 0 0 "The help message of pkgship dbs is error."

  LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
