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

# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."
    LOG_INFO "No params need to config."
    LOG_INFO "End to config params of the case."
}
# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-tensorflow"
    export LD_LIBRARY_PATH=/usr/lib64/python3.8/site-packages/tensorflow:$LD_LIBRARY_PATH
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
    rm -f report.txt b.py
    unset LD_LIBRARY_PATH
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}
main "$@"
