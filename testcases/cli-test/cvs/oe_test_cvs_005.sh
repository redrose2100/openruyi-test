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
    su cvsroot << EOF
echo "abc" >> tmp.txt
cvs diff -l 2>&1 < /dev/null | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -l"
    su cvsroot << EOF
echo " efg" >> dir/2.txt
cvs diff -R 2>&1 < /dev/null | grep 'diff -r1.1 2.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -R"
    su cvsroot << EOF
cvs add dir/2.txt tmp.txt 
cvs commit -l -m 'Added an optimization pass for tmp.txt' | grep 'new revision:'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs commit -l "
    su cvsroot << EOF
cvs diff -N | grep 'efg'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -N "
    su cvsroot << EOF
cvs diff -kk -c -r 1.1 -r 1.2 tmp.txt | grep '*** 0 ****'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -kk -c "
    su cvsroot << EOF
cvs diff -i -w -b -r 1.1 -r 1.2 tmp.txt | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -i -w -b "
    su cvsroot << EOF
cvs diff -I 'efg' -r 1.1 -r 1.2 tmp.txt | grep 'abc' && ! cvs diff -I 'abc' -r 1.1 -r 1.2 tmp.txt | grep '> abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -I "
    su cvsroot << EOF
cvs diff --binary -r 1.1 -r 1.2 tmp.txt | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff --binary "
    su cvsroot << EOF
cvs diff -a -r 1.1 -r 1.2 tmp.txt | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -a "
    su cvsroot << EOF
cvs diff -kk -r 1.1 -r 1.2 tmp.txt | grep 'abc'
EOF
    CHECK_RESULT $? 0 0 "Failed option: cvs diff -r "
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd $cvs_dir/../../
    unset CVSROOT cvs_dir testd_cvs_dir
    rm -rf cvs_test/cvs_testd_dir myProject/ cvs_test/ init/
    userdel -rf cvsroot;groupdel cvs
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
