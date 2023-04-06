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
    source "./init/cvs_complex.sh"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su cvsroot -c "cvs rannotate myProject 2>&1 | grep 'Annotations for myProject/1.txt'"
    CHECK_RESULT $? 0 0 "test cvs rannotate failed"
    su cvsroot -c "cvs -6 rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep '*** myProject/1.txt:1.1 .*'"
    CHECK_RESULT $? 0 0 "test cvs -6 failed"
    su cvsroot -c "cvs -q rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs -q failed"
    su cvsroot -c "cvs -r rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs -r failed"
    su cvsroot -c "cvs -w rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs -w failed"
    su cvsroot -c "cvs -n rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs -n failed"
    su cvsroot -c "cvs -T rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs  failed-T"
    su cvsroot -c "cvs -t rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep 'new file'"
    CHECK_RESULT $? 0 0 "test cvs -t failed"
    su cvsroot -c "cvs rdiff -r 1.1 -r 1.2 myProject 2>&1 | grep '.*myProject/1.txt:1.1 .*'"
    CHECK_RESULT $? 0 0 "test cvs rdiff failed"
    su cvsroot -c "cvs rlog myProject 2>&1 | grep 'RCS file:.*1.txt,v'"
    CHECK_RESULT $? 0 0 "test cvs rlog failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset CVSROOT cvs_dir testd_cvs_dir
    userdel -rf cvsroot;groupdel cvs
    pushd $run_dir
    rm -rf myProject/ cvs_test/ init/ passwd
    DNF_REMOVE
    popd
    LOG_INFO "End to restore the test environment."
}

main "$@"
