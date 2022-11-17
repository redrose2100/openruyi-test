#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
source "./init/cvs_complex.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cvs
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
echo "abc" >> tmp.txt
su cvsroot << EOF
cvs diff --ifdef=a | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ifdef=name"
    su cvsroot << EOF
cvs diff --ignore-all-space | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ignore-all-space"
    su cvsroot << EOF
cvs diff --ignore-blank-lines | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ignore-blank-lines"
    su cvsroot << EOF
cvs diff --ignore-case | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ignore-case"
    su cvsroot << EOF
cvs diff --ignore-matching-lines=regexp | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ignore-matching-lines=regexp"
    su cvsroot << EOF
cvs diff --ignore-space-change | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --ignore-space-change"
    su cvsroot << EOF
cvs diff --initial-tab | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --initial-tab"
    su cvsroot << EOF
cvs diff --left-column | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --left-column"
    su cvsroot << EOF
cvs diff --old-line-format=format | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --line-format=format"
    su cvsroot << EOF
cvs diff --minimal | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --minimal"
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
