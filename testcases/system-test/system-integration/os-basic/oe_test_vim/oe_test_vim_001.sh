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
# @Author    :   baolingling
# @Contact   :   baolingling@uniontech.com
# @Date      :   2024.4.9
# @License   :   Mulan PSL v2
# @Desc      :   vim command test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    file="test.file"
    echo 'Hello Word!' > ${file}
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    vim -N -u NONE -n -S common/copy_file.vim ${file}
    res1=$(grep -c "Hello" ${file})
    [[ "$res1" == "2" ]]
    CHECK_RESULT $? 0 0 "Failed to copy the file"
    vim -N -u NONE -n -S common/insert_file.vim ${file}
    grep 'Good' ${file}
    CHECK_RESULT $? 0 0 "Failed to insert the file"
    vim -N -u NONE -n -S common/insert_file_01.vim ${file}
    grep 'Happy' ${file}
    CHECK_RESULT $? 0 0 "Failed to insert line the file"
    vim -N -u NONE -n -S common/del_byte_file.vim ${file}
    grep 'Good' ${file}
    CHECK_RESULT $? 0 1 "Failed to delete byte the file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${file}
    LOG_INFO "End to restore the test environment."
}
main "$@"
