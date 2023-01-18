#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2022-01-04
# @License   :   Mulan PSL v2
# @Desc      :   graphviz function verification
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8  
    DNF_INSTALL graphviz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > first.dot << \EOF
digraph first2{
a;
b;
c;
d;
a->b;
b->d;
c->d;
}
EOF
    test -e  first.dot    
    CHECK_RESULT $? 0 0  "check first.dot is fail"
    dot -Tpng first.dot -o first.png
    test -e  first.png 
    CHECK_RESULT $? 0 0 "check first.png is fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf first.*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"


