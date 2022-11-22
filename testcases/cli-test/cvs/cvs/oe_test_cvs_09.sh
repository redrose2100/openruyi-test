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
cvs diff --side-by-side | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --side-by-side"
    su cvsroot << EOF
cvs diff --speed-large-files | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --speed-large-files"
    su cvsroot << EOF
cvs diff --suppress-common-lines | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --suppress-common-lines"
    su cvsroot << EOF
cvs diff -t | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -t"
    su cvsroot << EOF
cvs diff -T | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -T"
    su cvsroot << EOF
cvs diff --text | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --text"
    su cvsroot << EOF
cvs diff -u | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -u"
    su cvsroot << EOF
cvs diff -w | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -w"
    su cvsroot << EOF
cvs diff -W 1 | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: -W columns"
    su cvsroot << EOF
cvs diff -U 1 | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -U"
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
