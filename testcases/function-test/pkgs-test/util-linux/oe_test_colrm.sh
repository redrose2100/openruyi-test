#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025.06.06
# @License   :   Mulan PSL v2
# @Desc      :   colrm Command test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "util-linux"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    
    # Test if colrm is installed
    which colrm
    CHECK_RESULT $? 0 0 "colrm command not found"
    
    # Test basic functionality - remove columns from a string
    echo "123456789" | colrm 3 5 > test_output.txt
    grep "126789" test_output.txt
    CHECK_RESULT $? 0 0 "Failed to remove columns 3-5"
    
    # Test removing columns from start
    echo "123456789" | colrm 1 3 > test_output.txt
    grep "456789" test_output.txt
    CHECK_RESULT $? 0 0 "Failed to remove columns 1-3"
    
    # Test removing columns from end
    echo "123456789" | colrm 7 > test_output.txt
    grep "123456" test_output.txt
    CHECK_RESULT $? 0 0 "Failed to remove columns from 7 to end"
    
    # Test with multiple lines
    echo -e "123456789\nabcdefghi" | colrm 4 6 > test_output.txt
    grep "123789" test_output.txt
    CHECK_RESULT $? 0 0 "Failed to process multiple lines"
    grep "abcghi" test_output.txt
    CHECK_RESULT $? 0 0 "Failed to process multiple lines"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f test_output.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@" 
