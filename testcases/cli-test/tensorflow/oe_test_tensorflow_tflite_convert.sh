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
# @Author    :   wangsongsong;zouxun
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
    model
    LOG_INFO "End to prepare the test environment."
}
# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    # tflite_convert: 支持基础模型转换。使用 TFLiteConverter Python API 支持任何涉及量化或其他参数的转换(例如：SavedModels 签名，或者在 Keras 模型上自定义对象).
    tflite_convert  --saved_model_dir ./common/saved_model_dir --output_file tflite_convert_out
    CHECK_RESULT $? 0 0 "failed to convert model"
    tflite_convert --keras_model_file ./common/saved_model_keras_dir/ --output_file ./out --enable_v1_converter  --experimental_new_converter
    CHECK_RESULT $? 0 0 "failed to convert keras model"
    LOG_INFO "End to run test."
}
# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    test -f tflite_convert_out && rm -rf tflite_convert_out
    DNF_REMOVE 
    unset LD_LIBRARY_PATH
    test -f saved_model_dir && rm -rf saved_model_dir
    test -f ./common/saved_model_keras_dir/ && rm -rf ./common/saved_model_keras_dir/
    LOG_INFO "End to restore the test environment."
}
main "$@"
