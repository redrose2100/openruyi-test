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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of osinfo-db-import command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "osinfo-db-tools"
    pwd=`pwd`
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    wget https://releases.pagure.org/libosinfo/osinfo-db-20230308.tar.xz
    osinfo-db-import --local osinfo-db-20230308.tar.xz
    CHECK_RESULT $? 0 0 "Failed to import data"
    mkdir testdir
    cd testdir
    osinfo-db-export
    CHECK_RESULT $? 0 0 "Failed to export data"
    test -e osinfo-db-20230331.tar.xz
    CHECK_RESULT $? 0 0 "Export file does not exist"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $pwd
    rm -rf testdir osinfo-db-20230308.tar.xz
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


