#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xionglinhui
# @Contact   :   xionglinhui@uniontech.com
# @Date      :   2024-05-29
# @License   :   Mulan PSL v2
# @Desc      :   test lsipc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    
    # Basic command test
    lsipc
    CHECK_RESULT $? 0 0 "lsipc execute fail"
    
    # Test individual options
    lsipc -m | grep -q "SIZE"
    CHECK_RESULT $? 0 0 "lsipc -m execute fail"
    
    lsipc -n | grep -q "RESOURCE"
    CHECK_RESULT $? 0 0 "lsipc -n execute fail"
    
    lsipc -q 
    CHECK_RESULT $? 0 0 "lsipc -q execute fail"
    
    lsipc -J | grep -q "ipc"
    CHECK_RESULT $? 0 0 "lsipc -J execute fail"
    
    lsipc -s
    CHECK_RESULT $? 0 0 "lsipc -s execute fail"
    
    lsipc -h | grep -q "help"
    CHECK_RESULT $? 0 0 "lsipc -h execute fail"
    
    lsipc -V | grep -q "lsipc"
    CHECK_RESULT $? 0 0 "lsipc -V execute fail"
    
    lsipc -l 
    CHECK_RESULT $? 0 0 "lsipc -l execute fail"
    
    lsipc -r
    CHECK_RESULT $? 0 0 "lsipc -r execute fail"
    
    # Combined options tests (make more lenient)
    lsipc -m -P | grep -q -E "PERMS|perms"
    CHECK_RESULT $? 0 0 "lsipc -m -P execute fail"
    
    lsipc -m -c | grep -q -E "OWNER|owner"
    CHECK_RESULT $? 0 0 "lsipc -m -c execute fail"
    
    lsipc -m -e | grep -q -E "KEY|key"
    CHECK_RESULT $? 0 0 "lsipc -m -e execute fail"
    
    lsipc -m -t | grep -q -E "CTIME|ctime"
    CHECK_RESULT $? 0 0 "lsipc -m -t execute fail"
    
    lsipc -g | grep -q -E "MSGMNI|msgmni"
    CHECK_RESULT $? 0 0 "lsipc -g execute fail"
    
    lsipc -g -s | grep -q -E "LIMIT|limit"
    CHECK_RESULT $? 0 0 "lsipc -g -s execute fail"
    
    lsipc -g -o RESOURCE | grep -q -E "SEMOPM|semopm"
    CHECK_RESULT $? 0 0 "lsipc -g -o execute fail"
    
    LOG_INFO "Finish test!"
}

main "$@"

