#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2022-12-19
# @License   :   Mulan PSL v2
# @Desc      :   package procps-ng-pmap
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat > /home/test_procps-ng-pmap.c << EOF
int main(void)
{
while(1);
return 0;
}
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    gcc /home/test_procps-ng-pmap.c -o /home/test_procps-ng-pmap
    CHECK_RESULT $? 0 0 "Compilation failed"
    /home/test_procps-ng-pmap &
    sleep 5
    pid=$(ps -ef | grep "/home/test_procps-ng-pmap" | awk 'NR==1' | awk -F " " '{print $2}')
    pmap "$pid" | grep -E "total *[0-9]*K"
    CHECK_RESULT $? 0 0 "Pmap execution failed"
    pmap -x "$pid" | grep "Address"
    CHECK_RESULT $? 0 0 "Pmap -x execution failed"
    pmap -d "$pid" | grep "Address" | grep "Device"
    CHECK_RESULT $? 0 0 "Pmap -d execution failed"
    pmap -V | grep -E "pmap from procps-ng [0-9]*.[0-9]*.[0-9]*"
    CHECK_RESULT $? 0 0 "Pmap -V  execution failed"
    pmap -X  "$pid" | grep "Address" | grep "Device" | grep "Perm"
    CHECK_RESULT $? 0 0 "Pmap -X execution failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 "$pid"
    rm -rf /home/test_procps-ng-pmap.c /home/test_procps-ng-pmap
    LOG_INFO "End to restore the test environment."
}

main "$@"

