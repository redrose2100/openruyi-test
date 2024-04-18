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
# @Author    :   wanghaiyang
# @Contact   :   wanghaiyang@uniontech.com
# @Date      :   2024-03-21
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test -ls
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    touch test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    TEMP=$(ls -ahl )
    [[ $TEMP == *"test"* ]]
    CHECK_RESULT $? 0 0 "Failed to view the owner of the file"
    TEMP=$(ls --color=no)
    [[ $TEMP == *"test"* ]]
    CHECK_RESULT $? 0 0 "Failed to query a non-color file"
    TEMP=$(ls -lR /bin)
    [[ $TEMP == *"usr/bin"* ]]
    CHECK_RESULT $? 0 0 "Execution error"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf test.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
