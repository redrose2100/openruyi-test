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
# @Desc      :   for using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > test_for.sh <<EOF
#!/bin/utshell
for i in alksdjflaksd flkasdf laksdf askdjf
do
echo \$i
done
EOF
    test -f test_for.sh 
    CHECK_RESULT $? 0 0 "create file failed"
    utshell test_for.sh > for_result.log
    grep -Pzo 'alksdjflaksd\nflkasdf\nlaksdf\naskdjf' for_result.log
    CHECK_RESULT $? 0 0 "The for command is abnormal"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf test_for.sh for_result.log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
