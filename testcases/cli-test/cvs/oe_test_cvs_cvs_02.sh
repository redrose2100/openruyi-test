#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/03/01
# @License   :   Mulan PSL v2
# @Desc      :   Test cvs
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cvs tar"
    tar -zxvf common/test.tar.gz 
    source "./init/cvs_common.sh"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cvs -d $testd_cvs_dir init && test -d $testd_cvs_dir
    CHECK_RESULT $? 0 0 "test cvs -d failed"
    su cvsroot -c 'cvs init' && test -d $cvs_dir
    CHECK_RESULT $? 0 0 "test cvs init failed"
    su cvsroot -c "cd cvs_test/cvs_project;cvs import -m \"my cvs project\" myProject cvsroot start | grep 'N myProject/1.txt'"
    CHECK_RESULT $? 0 0 "test cvs import failed"
    cvs -d $cvs_dir checkout myProject | grep 'myProject/1.txt'
    CHECK_RESULT $? 0 0 "test cvs checkout failed"
    chown -R cvsroot.cvs myProject;chmod -R 775 myProject;
    pushd myProject
    touch tmp.txt 4.txt && cvs add tmp.txt  2>&1 < /dev/null | grep 'cvs add: scheduling file .*tmp.txt.* for addition'
    CHECK_RESULT $? 0 0 "test cvs add failed"
    cvs -4 add 4.txt  2>&1 < /dev/null | grep 'cvs add: scheduling file .*4.txt.* for addition'
    CHECK_RESULT $? 0 0 "test cvs -4 failed"
    chown -R cvsroot.cvs tmp.txt;
    su cvsroot -c "cvs commit -m 'add tmp.txt' 2>&1 | grep 'cvs commit: Examining .'"
    CHECK_RESULT $? 0 0 "test cvs commit failed"
    su cvsroot -c "cvs annotate tmp.txt 2>&1 | grep 'Annotations for tmp.txt'"
    CHECK_RESULT $? 0 0 "test cvs annotate failed"
    su cvsroot -c "cvs log tmp.txt 2>&1 < /dev/null | grep 'Working file: tmp.txt'"
    CHECK_RESULT $? 0 0 "test cvs log failed"
    su cvsroot -c "cvs diff 2>&1 | grep 'cvs diff: Diffing .'"
    CHECK_RESULT $? 0 0 "test cvs diff failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset CVSROOT cvs_dir testd_cvs_dir
    userdel -rf cvsroot;groupdel cvs
    rm -rf myProject/ cvs_test/ init/ passwd tmp.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
