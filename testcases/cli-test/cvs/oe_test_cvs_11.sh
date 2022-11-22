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
    source "./init/cvs_complex.sh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su cvsroot << EOF 
cvs history -c | grep 'M .*+0000 cvsroot 1.2 1.txt   myProject     == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -c"
    su cvsroot << EOF 
cvs history -c -f 1.txt | grep 'M .*+0000 cvsroot 1.2 1.txt myProject == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -f"
    su cvsroot << EOF 
cvs history -c -D $DATE -f 1.txt | grep 'M .*+0000 cvsroot 1.2 1.txt myProject == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -D"
    su cvsroot << EOF 
cvs history -e | grep 'A .*+0000 cvsroot 1.1 tmp.txt myProject     == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -e"
    su cvsroot << EOF 
cvs history -e -l -f 1.txt | grep 'M .* +0000 cvsroot 1.2 1.txt myProject == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -l"
    su cvsroot << EOF 
cvs history -e -u cvsroot | grep 'A .* +0000 cvsroot 1.1 tmp.txt myProject     == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -u"
    su cvsroot << EOF 
cvs history -e -p myProject | grep 'A .* +0000 cvsroot 1.1 tmp.txt myProject     == /home/workspace/mugen/testcases/cli-test/cvs/myProject'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history -p"
    su cvsroot << EOF 
cvs rannotate myProject 2>&1 | grep 'Annotations for myProject/1.txt'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history rannotate"
    su cvsroot << EOF 
cvs rdiff -c -r 1.1 -r 1.2 myProject 2>&1 | grep '*** myProject/1.txt:1.1 .*'
EOF
    CHECK_RESULT $? 0 0 "Failed option: history rdiff"
    su cvsroot << EOF 
cvs rlog myProject 2>&1 | grep 'RCS file: /home/workspace/mugen/testcases/cli-test/cvs/cvs_test/cvs_init_dir/myProject/1.txt,v' 
EOF
    CHECK_RESULT $? 0 0 "Failed option: history rlog"
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
