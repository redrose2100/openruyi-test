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
    source "./init/cvs_remote_make.sh"
    source "./init/cvs_complex.sh"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su cvsroot -c "echo y | cvs release -d dir && ! test -d dir"
    CHECK_RESULT $? 0 0 "test cvs release failed"
    P_SSH_CMD --cmd "yum install cvs -y;export CVSROOT=:pserver:cvsroot@${NODE2_IPV4}:2401${cvs_dir};echo cvs | cvs login;cvs -z 1 log; unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "test cvs login failed"
    P_SSH_CMD --cmd "export CVSROOT=:pserver:cvsroot@${NODE2_IPV4}:2401${cvs_dir};echo cvs | cvs login;cvs -z 1 log; unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "test cvs -z failed"
    P_SSH_CMD --cmd "export CVSROOT=:pserver:cvsroot@${NODE2_IPV4}:2401${cvs_dir};echo cvs | cvs login;cvs logout;unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "test cvs logout failed"
    P_SSH_CMD --cmd "export CVSROOT=:pserver:cvsroot@${NODE2_IPV4}:2401${cvs_dir};echo cvs | cvs login;unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "test cvs pserver failed"
    SSH_SCP ${run_dir}/init/ext.sh root@${NODE2_IPV4}:/root "=*W5FTY3em"
    P_SSH_CMD --cmd "$(expect ext.sh 2>&1 | grep 'U myProject/1.txt')" --node 2 
    P_SSH_CMD --cmd  "rm -rf ext.sh myProject;yum remove cvd -y" --node 2
    CHECK_RESULT $? 0 0 "test cvs server failed"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    source "./init/cvs_remote_clean.sh"
    unset CVSROOT cvs_dir testd_cvs_dir 
    userdel -rf cvsroot;groupdel cvs
    pushd $run_dir
    rm -rf myProject/ cvs_test/ init/ passwd
    DNF_REMOVE
    popd
    LOG_INFO "End to restore the test environment."
}

main "$@"
