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
    echo "abc" >> tmp.txt
    su cvsroot -c "cvs tag rel-1-0 | grep 'T tmp.txt'"
    CHECK_RESULT $? 0 0 "test cvs tag failed"
    su cvsroot -c "cvs export -r rel-1-0 myProject | grep 'U myProject/tmp.txt'"
    CHECK_RESULT $? 0 0 "test cvs export failed"
    su cvsroot -c "cvs checkout myProject;cvs watch on tmp.txt;cvs add tmp.txt;cvs commit -m 'commit change';ls -la tmp.txt | grep '\-r--r--r--.*tmp.txt'"
    CHECK_RESULT $? 0 0 "test cvs watch failed"
    su cvsroot -c "cvs edit -a edit tmp.txt 1.txt;cvs watchers tmp.txt | grep 'tmp.txt	cvsroot	tedit'"
    CHECK_RESULT $? 0 0 "test cvs edit failed"
    su cvsroot -c "cvs watchers tmp.txt | grep 'tmp.txt	cvsroot	tedit'"
    CHECK_RESULT $? 0 0 "test cvs watchers failed"
    su cvsroot -c "cvs editors tmp.txt | grep 'tmp.txt	cvsroot'"
    CHECK_RESULT $? 0 0 "test cvs editors failed"
    su cvsroot -c "cvs unedit tmp.txt;cvs watchers tmp.txt 1.txt | grep '1.txt	cvsroot	tedit'"
    CHECK_RESULT $? 0 0 "test cvs unedit failed"
    su cvsroot -c "cvs history tmp.txt 2>&1 | grep 'O .* +0000 cvsroot myProject =myProject=.*'"
    CHECK_RESULT $? 0 0 "test cvs history failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset CVSROOT cvs_dir testd_cvs_dir
    userdel -rf cvsroot;groupdel cvs
    pushd $run_dir
    rm -rf myProject cvs_test/ init/ passwd
    DNF_REMOVE
    popd
    LOG_INFO "End to restore the test environment."
}

main "$@"
