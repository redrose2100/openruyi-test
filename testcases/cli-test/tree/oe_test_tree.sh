#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuhuiqian
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023.6.20
# @License   :   Mulan PSL v2
# @Desc      :   tree Command test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir /tmp/test
    path=/tmp/test
    mkdir ${path}/tree1 ${path}/tree2 ${path}/tree3
    touch ${path}/tree_test1 ${path}/tree_test2
    DNF_INSTALL "tree"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep tree
    CHECK_RESULT $? 0 0 "Return value error"
    tree --version
    CHECK_RESULT $? 0 0 "Version is error"
    cd ${path}&&tree > test1.txt
    grep tree_test1 ${path}/test1.txt
    CHECK_RESULT $? 0 0 " test1.txt file error"
    tree -d -L 3 > test2.txt
    grep tree1 ${path}/test2.txt
    CHECK_RESULT $? 0 0 " test2.txt file error"
    tree -d -f -h -L  3 > test3.txt
    grep tree2 ${path}/test3.txt
    CHECK_RESULT $? 0 0 " test3.txt file error"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
