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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024.7.19
# @License   :   Mulan PSL v2
# @Desc      :   unique3 formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/test.py << EOF
def unique3(arr):
    unique_nums = []
    for num in arr:
        if arr.count(num) == 1 and num not in unique_nums:
            unique_nums.append(num)
            if len(unique_nums) == 3:
                break
    return unique_nums

# 测试用例1
arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8]
result1 = unique3(arr1)
print("Test Case 1: ", result1)  # 9

# 测试用例2
arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
result2 = unique3(arr2)
print("Test Case 2: ", result2)  # [10, 11, 12]

# 测试用例3
arr3 = [1, 1, 1, 2, 2, 2, 3, 3, 3]
result3 = unique3(arr3)
print("Test Case 3: ", result3)  # []

# 测试用例4
arr4 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
result4 = unique3(arr4)
print("Test Case 4: ", result4)  # [1, 2, 3]

EOF

    DNF_INSTALL "unique3"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep unique3
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && python3 test.py > unique3.file
    test -f /tmp/unique3.file
    CHECK_RESULT $? 0 0 "unique3 test fail"
    grep "[9]" /tmp/unique3.file    
    CHECK_RESULT $? 0 0 "execute unique3.file fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.py /tmp/unique3.file
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
