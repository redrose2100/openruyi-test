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
    source "./init/cvs_common.sh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cvs -d $testd_cvs_dir init && ls -la $testd_cvs_dir | grep -cE 'CVSROOT' | grep '1'
    CHECK_RESULT $? 0 0 "Failed option: cvs -d"
    su cvsroot -c 'cvs init' && ls -la $cvs_dir | grep -cE 'CVSROOT' | grep '1'
    CHECK_RESULT $? 0 0 "Failed option: cvs init"
    su cvsroot -c 'cd cvs_test/cvs_project && cvs import -m "my cvs project" myProject cvsroot start | grep 'N myProject/1.txt''
    CHECK_RESULT $? 0 0 "Failed option: cvs import"
    cvs -d $cvs_dir checkout myProject | grep 'myProject/1.txt'
    CHECK_RESULT $? 0 0 "Failed option: cvs checkout"
    chown -R cvsroot.cvs myProject;chmod -R 775 myProject;
    cd myProject && touch tmp.txt 4.txt && cvs add tmp.txt  2>&1 < /dev/null | grep 'cvs add: scheduling file .*tmp.txt.* for addition'
    CHECK_RESULT $? 0 0 "Failed option: cvs add"
    cvs -4 add 4.txt  2>&1 < /dev/null | grep 'cvs add: scheduling file .*4.txt.* for addition'
    CHECK_RESULT $? 0 0 "Failed option: cvs -4"
    chown -R cvsroot.cvs tmp.txt;
    su cvsroot << EOF
cvs commit -m 'add tmp.txt' 2>&1 | grep 'cvs commit: Examining .'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs commit"
    su cvsroot << EOF
cvs annotate tmp.txt 2>&1 | grep 'Annotations for tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs annotate"
    su cvsroot << EOF
cvs log tmp.txt 2>&1 < /dev/null | grep 'Working file: tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs log"
    su cvsroot << EOF
cvs diff 2>&1 | grep 'cvs diff: Diffing .'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff "
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
