#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   liuzhaoda
#@Contact       :   1048074322@qq.com
#@Date          :   2022-09-19
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-env2mfile
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc g++"
    tar -xvf common/0.63/test_1.tgz&&cd ./test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson env2mfile --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-env2mfile --help failed"
    meson env2mfile -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-env2mfile -h failed"
    meson env2mfile --cross -o current_cross.txt --gccsuffix=0.45 --system=linux --cpu=arm7a --cpu-family=arm
    CHECK_RESULT $? 0 0 "meson-env2mfile --gccsuffix failed"
    meson env2mfile --cross -o current_cross.txt --system=linux --cpu=arm7a --cpu-family=arm
    CHECK_RESULT $? 0 0 "meson-env2mfile --cross or -o or --system or --cpu or --cpu-family failed"
    meson env2mfile --cross -o current_cross.txt --endian=big --system=linux --cpu=arm7a --cpu-family=arm
    CHECK_RESULT $? 0 0 "meson-env2mfile --endian or --cross or -o or --system or --cpu or --cpu-family failed"
    meson env2mfile --native -o current_native.txt
    CHECK_RESULT $? 0 0 "meson-env2mfile --native failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./../test_1
    rm -f ./../current_cross.txt ./../current_native.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"