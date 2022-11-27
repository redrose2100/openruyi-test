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
# @Desc      :   Test cvs
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
    su cvsroot << EOF
cvs rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs rtag"
    su cvsroot << EOF
cvs -f rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs -f"
    su cvsroot << EOF
cvs -x rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs -x"
    su cvsroot << EOF
cvs -a rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs -a"
    su cvsroot << EOF
cvs remove tmp.txt 2>&1 | grep 'cvs remove: 1 file exists; remove it first'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs remove"
   su cvsroot << EOF
cvs update tmp.txt
cvs status tmp.txt 2>&1 | grep 'Sticky Tag:.*(none)'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs update"
    su cvsroot << EOF
cvs status tmp.txt 2>&1 | grep 'Sticky Tag:.*(none)'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs status"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd $cvs_dir/../../
    unset CVSROOT cvs_dir testd_cvs_dir
    userdel -rf cvsroot;groupdel cvs
    rm -rf cvs_test/cvs_testd_dir myProject cvs_test/ init/ passwd
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
