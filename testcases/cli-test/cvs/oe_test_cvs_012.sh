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
    su cvsroot << EOF
cvs rtag -b rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag -b"
    su cvsroot << EOF
cvs rtag -a rel-1-0 myProject 2>&1 | grep 'W myProject/1.txt : rel-1-0 already exists on branch 1.2 : NOT MOVING tag to version 1.2'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag -a"
    su cvsroot << EOF
cvs rtag -r 1.2 abc myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag -r"
    su cvsroot << EOF
cvs rtag -B -r 1.2 -F abc myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag -B"
    su cvsroot << EOF
cvs rtag -B -d rel-1-0 myProject 2>&1 | grep 'cvs rtag: Untagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag -d"
    su cvsroot << EOF
cvs remove -f 1.txt 2>&1 | grep 'cvs remove: scheduling .* for removal'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs remove -f "
    su cvsroot << EOF
cvs remove tmp.txt 2>&1 | grep 'cvs remove: 1 file exists; remove it first'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs remove"
   su cvsroot << EOF
cvs update -A tmp.txt
cvs status tmp.txt 2>&1 | grep 'Sticky Tag:.*(none)'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs update -A"
   su cvsroot << EOF
cvs update -C 2>&1 | grep 'R 1.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs update -C"
   su cvsroot << EOF
cvs update -d dir 2>&1 | grep 'cvs update: Updating dir'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs update -d"
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
