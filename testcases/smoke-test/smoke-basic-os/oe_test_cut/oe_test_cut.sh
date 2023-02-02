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
# @Date      :   2023.2.2
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-cut
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_cut  <<EOF
aa bb
cc dd
ee ff
gg hh
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cut --help 
    CHECK_RESULT $? 0 0 "Return value error"
    cut --v
    CHECK_RESULT $? 0 0 "Version is error"
    cut -d ' ' -f 1 /tmp/test_cut > /tmp/ceshi
    grep 'aa\|ee\|dd' /tmp/ceshi
    CHECK_RESULT $? 0 0 "column ceshi fail"    
    cut -c 2-4 /tmp/test_cut > /tmp/ceshi
    grep 'a b\|c  d\|e   f' /tmp/ceshi
    CHECK_RESULT $? 0 0 "character ceshi fail"
    cut -b 5 /tmp/test_cut > /tmp/ceshi
    grep 'a\|b\|d' /tmp/ceshi 
    CHECK_RESULT $? 0 0 "byte ceshi error"      
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test_cut
    rm -tf /tmp/ceshi
    LOG_INFO "Finish environment cleanup!"
}

main $@
