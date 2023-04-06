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
    su cvsroot -c "cvs rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'"
    CHECK_RESULT $? 0 0 "test cvs rtag failed"
    su cvsroot -c "cvs -f rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'"
    CHECK_RESULT $? 0 0 "test cvs -f failed"
    su cvsroot -c "cvs -x rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'"
    CHECK_RESULT $? 0 0 "test cvs -x failed"
    su cvsroot -c "cvs -a rtag rel-1-0 myProject 2>&1 | grep 'cvs rtag: Tagging myProject'"
    CHECK_RESULT $? 0 0 "test cvs -a failed"
    su cvsroot -c "cvs remove tmp.txt 2>&1 | grep 'cvs remove: 1 file exists; remove it first'"
    CHECK_RESULT $? 0 0 "test cvs remove failed"
    su cvsroot -c "cvs update tmp.txt;cvs status tmp.txt 2>&1 | grep 'Sticky Tag:.*(none)'"
    CHECK_RESULT $? 0 0 "test cvs update failed"
    su cvsroot -c "cvs status tmp.txt 2>&1 | grep 'Sticky Tag:.*(none)'"
    CHECK_RESULT $? 0 0 "test cvs status failed"
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
