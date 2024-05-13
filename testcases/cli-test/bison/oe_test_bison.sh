#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.6.2
# @License   :   Mulan PSL v2
# @Desc      :   Bison Command Test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir -p /tmp/test
    path=/tmp/test
    cat > ${path}/test.set  <<EOF
A=[a,b,c,d,z]
B=[c,d,e, f ] // test comment
C=[e,f,g,h,z]
D=[x,y,z]
E = A ∪ B ∩ C - A ∩ B ∪ D
PRINT A
PRINT E
EOF

    DNF_INSTALL "gcc bison flex"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cp ./common/set_calc.l ./common/set_calc.y /tmp/test
    cd ${path}&&bison -d set_calc.y
    test -f ${path}/set_calc.tab.c -a ${path}/set_calc.tab.h
    CHECK_RESULT $? 0 0 "bison file fails"
    flex set_calc.l
    test -f lex.yy.c
    CHECK_RESULT $? 0 0 "flex files fails"
    gcc -std=c99 -o set_calc set_calc.tab.c lex.yy.c 
    test -f set_calc
    CHECK_RESULT $? 0 0 "set_calc file fails"
    ./set_calc < test.set > ${path}/analysis_file
    grep "A: \[a,b,c,d,z]" ${path}/analysis_file
    CHECK_RESULT $? 0 0 "analysis file fails"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
