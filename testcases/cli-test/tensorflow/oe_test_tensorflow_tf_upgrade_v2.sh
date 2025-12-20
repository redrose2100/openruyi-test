#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com 
# @Date      :   2022/03/06
# @License   :   Mulan PSL v2
# @Desc      :   Test saved_model_cli 
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    get_tensorflow
    LOG_INFO "End to prepare the test environment."
}
# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    #将TensorFlow1的代码升级为TensorFlow2的代码 
    tf_upgrade_v2 --infile ./common/model.py --outfile b.py
    CHECK_RESULT $? 0 0 "failed to update code"
    LOG_INFO "End to run test."
}
# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    test -f report.txt && rm -f report.txt 
    test -f b.py && rm -f b.py
    unset LD_LIBRARY_PATH
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}
main "$@"
