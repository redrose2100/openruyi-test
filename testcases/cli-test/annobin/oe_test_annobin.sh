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
# @Date      :   2023.5.23
# @License   :   Mulan PSL v2
# @Desc      :   Vulnerability Anobin Test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir -p /tmp/test_anno
    path=/tmp/test_anno
    cat > ${path}/test.c  <<EOF
#include<stdio.h>
int main(void)
{
printf("Hello，world!\n");
return 0;
}
EOF

    DNF_INSTALL "annobin gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd ${path}&&gcc --print-file-name=plugin > ${path}/test1
    path1=$(cat /tmp/test_anno/test1)
    grep "${path1}" ${path}/test1
    CHECK_RESULT $? 0 0 "directory file error"
    ls "${path1}" > ${path}/test2
    grep "annobin.so" ${path}/test2
    CHECK_RESULT $? 0 0 "Library files fails"
    gcc -fplugin=annobin test.c
    ./a.out > ${path}/test3
    grep "Hello，world!" ${path}/test3
    CHECK_RESULT $? 0 0 "executable file fails"
    rm ${path}/a.out
    gcc -fplugin=annobin -fplugin-arg-annobin-verbose test.c
    test -f ${path}/a.out
    CHECK_RESULT $? 0 0 "a.out file fails"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
