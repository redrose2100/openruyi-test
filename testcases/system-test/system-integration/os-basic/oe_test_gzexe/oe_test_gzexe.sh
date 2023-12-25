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
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-12-20
# @License   :   Mulan PSL v2
# @Desc      :   压缩执行文件-gzexe
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat > /tmp/test.c << EOF
    #include <stdio.h>
    void main()
    {
    printf("Hello, world!\n");
    }
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    gzexe /tmp/test.c| grep %
    CHECK_RESULT $? 1 0 "gzexe function error"
    gzexe -d /tmp/test.c
    CHECK_RESULT $? 0 0 "gzexe function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.c
    rm -rf /tmp/test.c~
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
