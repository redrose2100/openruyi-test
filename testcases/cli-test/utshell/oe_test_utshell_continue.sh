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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2024.06.27
# @License   :   Mulan PSL v2
# @Desc      :   continue using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    mkdir /tmp/test_continue
    cd /tmp/test_continue || exit
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > test_for1.sh <<EOF
#!/bin/utshell
for((i=3;i>0;i--)); do
for((j=3;j>0;j--)); do
if((j==2)); then
continue
fi
printf "%s %s\n" \${i} \${j}
done
done
EOF
    test -f test_for1.sh
    CHECK_RESULT $? 0 0 "create file failed"
    utshell test_for1.sh > for_result1.log
    grep -Pzo '3 3\n3 1\n2 3\n2 1\n1 3\n1 1' for_result1.log
        cat > test_for2.sh <<EOF
#!/bin/utshell
for((i=3;i>0;i--)); do
for((j=3;j>0;j--)); do
if((j==2)); then
continue 2
fi
printf "%s %s\n" \${i} \${j}
done
done
EOF
    test -f test_for2.sh
    CHECK_RESULT $? 0 0 "create file2 failed"
    utshell test_for2.sh > for_result2.log
    grep -Pzo '3 3\n2 3\n1 3' for_result2.log
    CHECK_RESULT $? 0 0 "The for command is abnormal"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf /tmp/test_continue
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
