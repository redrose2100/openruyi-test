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
echo "abc" >> tmp.txt
    su cvsroot << EOF
cvs diff -y | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -y"
    su cvsroot << EOF
cvs tag rel-1-0 | grep 'T tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs tag"
    su cvsroot << EOF
cvs export -r rel-1-0 myProject | grep 'U myProject/tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs export"
    su cvsroot << EOF
cvs checkout myProject
cvs watch on tmp.txt
cvs add tmp.txt 
cvs commit -m 'commit change'
ls -la tmp.txt | grep '\-r--r--r--.*tmp.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs watch"
    su cvsroot << EOF
cvs edit -a edit tmp.txt 1.txt
cvs watchers tmp.txt | grep 'tmp.txt	cvsroot	tedit'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs edit"
    su cvsroot << EOF 
cvs watchers tmp.txt | grep 'tmp.txt	cvsroot	tedit'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs watchers"

    su cvsroot << EOF 
cvs editors tmp.txt | grep 'tmp.txt	cvsroot'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs editors"
    su cvsroot << EOF 
cvs unedit tmp.txt
cvs watchers tmp.txt 1.txt | grep '1.txt	cvsroot	tedit'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs unedit"
    su cvsroot << EOF 
cvs history -a tmp.txt 2>&1 | grep 'O .* +0000 cvsroot myProject =myProject= /home/workspace/mugen/testcases/cli-test/cvs/myProject/*'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -a"
    su cvsroot << EOF 
cvs history -e -b myProject 2>&1 | grep '.*+0000 cvsroot 1.3 tmp.txt myProject == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -b"
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
