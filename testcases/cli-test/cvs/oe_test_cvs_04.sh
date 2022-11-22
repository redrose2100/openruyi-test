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
    source "./init/cvs_common.sh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ! cvs --help watchers 2>&1 | grep 'Unknown command' && cvs --help watchers 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: cvs --help-options"
    cvs -d $testd_cvs_dir init && ls -la $testd_cvs_dir | grep -cE 'CVSROOT' | grep '1'
    CHECK_RESULT $? 0 0 "Failed option: cvs -d"
    su cvsroot -c 'cvs init' && ls -la $cvs_dir | grep -cE 'CVSROOT' | grep '1'
    CHECK_RESULT $? 0 0 "Failed option: cvs init"
    su cvsroot -c 'cd cvs_test/cvs_project && cvs import -m "my cvs project" myProject cvsroot start | grep 'N myProject/1.txt''
    CHECK_RESULT $? 0 0 "Failed option: cvs import"
    cvs -d $cvs_dir checkout myProject | grep 'myProject/1.txt'
    CHECK_RESULT $? 0 0 "Failed option: cvs checkout"
    chown -R cvsroot.cvs myProject;chmod -R 775 myProject;
    cd myProject && touch tmp.txt && cvs add tmp.txt  2>&1 < /dev/null | grep 'cvs add: scheduling file .*tmp.txt.* for addition'
    CHECK_RESULT $? 0 0 "Failed option: cvs add"
    chown -R cvsroot.cvs tmp.txt;
    su cvsroot << EOF
cvs commit -m 'add tmp.txt' 2>&1 < /dev/null | wc -l | grep '7'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs commit"
    su cvsroot << EOF
echo "abc" >> tmp.txt
cvs add tmp.txt -m  2>&1 < /dev/null 
cvs commit -m 'add tmp.txt' 2>&1 < /dev/null | wc -l | grep '7'
EOF
    su cvsroot << EOF
cvs annotate tmp.txt 2>&1 < /dev/null | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs annotate"
    su cvsroot << EOF
cvs log tmp.txt 2>&1 < /dev/null | grep 'Working file: tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs log"
    su cvsroot << EOF
cvs diff -kk -u -r 1.1 -r 1.2 tmp.txt | grep '+abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -kk -u "
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
