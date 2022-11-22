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
    source "../init/cvs_remote_make.sh"
    source "./init/cvs_complex.sh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su cvsroot << EOF
echo y | cvs release -d dir && ! ls -la 2>&1 | grep 'dir'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs release"
    P_SSH_CMD --cmd "yum -y install cvs;export CVSROOT=:pserver:cvsroot@10.208.134.178:2401${cvs_dir};echo cvs | cvs login;unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "Failed option: cvs login"
    P_SSH_CMD --cmd "export CVSROOT=:pserver:cvsroot@10.208.134.178:2401${cvs_dir};echo cvs | cvs login;cvs logout;unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "Failed option: cvs logout"
    P_SSH_CMD --cmd "export CVSROOT=:pserver:cvsroot@10.208.134.178:2401${cvs_dir};echo cvs | cvs login;unset CVSROOT" --node 2 
    CHECK_RESULT $? 0 0 "Failed option: cvs pserver"
    SSH_SCP ${run_dir}/init/ext.sh root@10.208.12.171:/root "=*W5FTY3em"
    P_SSH_CMD --cmd "$(expect ext.sh 2>&1 | grep 'U myProject/1.txt')" --node 2 
    P_SSH_CMD --cmd  "rm -rf ext.sh myProject" --node 2
    CHECK_RESULT $? 0 0 "Failed option: cvs server"
    LOG_INFO "Finish test!"

}
function post_test() {
    LOG_INFO "start environment cleanup."
    cd $cvs_dir/../../
    source "./init/cvs_remote_clean.sh"
    cd $cvs_dir/../../
    unset CVSROOT cvs_dir testd_cvs_dir
    rm -rf cvs_test/cvs_testd_dir myProject cvs_test/ init/
    userdel -rf cvsroot;groupdel cvs
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
