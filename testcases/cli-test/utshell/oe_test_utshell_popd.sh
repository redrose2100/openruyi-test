#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xianglongfei
# @Contact   :   xianglongfei@uniontech.com
# @Date      :   2024.08.20
# @License   :   Mulan PSL v2
# @Desc      :   popd using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    mkdir -p /tmp/dir1 /tmp/dir2 /tmp/dir3 /tmp/dir4
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp || exit    
    utshell -c "popd --help" | grep -i popd
    CHECK_RESULT $? 0 0 "popd --help failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; pwd | grep -i /tmp/dir4"
    CHECK_RESULT $? 0 0 "pushd execution failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; popd; pwd | grep -i /tmp/dir3"
    CHECK_RESULT $? 0 0 "popd execution failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; popd; popd -n; pwd | grep -i /tmp/dir3"
    CHECK_RESULT $? 0 0 "popd -n execution failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; popd; popd -n; pushd /tmp/dir4; pushd /tmp/dir2; pwd | grep -i /tmp/dir2"
    CHECK_RESULT $? 0 0 "pushd execution failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; popd; popd -n; pushd /tmp/dir4; pushd /tmp/dir2; popd +1; pwd | grep -i /tmp/dir2"
    CHECK_RESULT $? 0 0 "popd +1 execution failed"
    utshell -c "pushd /tmp/dir1; pushd /tmp/dir2; pushd /tmp/dir3; pushd /tmp/dir4; popd; popd -n; pushd /tmp/dir4; pushd /tmp/dir2; popd +1; popd -1; pwd | grep -i /tmp/dir2"
    CHECK_RESULT $? 0 0 "popd -1 execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf /tmp/dir1 /tmp/dir2 /tmp/dir3 /tmp/dir4
    LOG_INFO "Finish environment cleanup!"
}

main "$@"