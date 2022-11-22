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
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test cvs service function
# #############################################

source "../common/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "cvs"
    tar -zxvf common/test.tar.gz
    source "./init/cvs_complex.sh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
echo "abc" >> tmp.txt
    su cvsroot << EOF
cvs diff -n | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -n"
    su cvsroot << EOF
cvs diff --new-file | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --new-file"
    su cvsroot << EOF
cvs diff --new-group-format=format | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --new-group-format=format"
    su cvsroot << EOF
cvs diff --new-line-format=format | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --new-line-format=format"
    su cvsroot << EOF
cvs diff --old-group-format=format | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --old-group-format=format"
    su cvsroot << EOF
cvs diff --old-line-format=format | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --old-line-format=format"
    su cvsroot << EOF
cvs diff -p | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -p"
    su cvsroot << EOF
cvs diff --rcs | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --rcs"
    su cvsroot << EOF
cvs diff -s | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -s"
    su cvsroot << EOF
cvs diff --show-c-function | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --show-c-function"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd $cvs_dir/../../
    unset CVSROOT cvs_dir testd_cvs_dir
    rm -rf cvs_test/cvs_testd_dir myProject cvs_test/ init/
    userdel -rf cvsroot;groupdel cvs
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
