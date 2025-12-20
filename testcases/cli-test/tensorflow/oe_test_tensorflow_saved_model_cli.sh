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
source "common/lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    get_tensorflow

    DNF_INSTALL "python3-tensorflow"
    old_LD_LIBRARY_PATH=LD_LIBRARY_PATH                          
    tspath=$(dirname $(find / -name libtensorflow_framework.so*)) 
    export LD_LIBRARY_PATH=$tspath:$LD_LIBRARY_PATH              
    python3 ./common/saved_model.py
    wait
    python3 ./common/gen_tf_keras.model.py
    wait
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # 模型保存
    saved_model_cli show --dir ./common/saved_model_keras_dir/ --tag_set serve
    CHECK_RESULT $? 0 0 "failed to show model"
    #扫描一个特定的MetaGraph
    saved_model_cli scan --dir ./common/saved_model_dir --tag_set serve
    CHECK_RESULT $? 0 0 "failed to scan model"
    #convert 要将SavedModel转换为有TensorRT操作的模型
    saved_model_cli convert --dir ./common/saved_model_dir --output_dir ./test_out  --tag_set serve tensorrt
    CHECK_RESULT $? 0 0 "failed to convert model"
    #run 可运行计算图计算，传递输入，然后显示输出，还可以选择保存
    saved_model_cli run --dir ./common/saved_model_dir --signature_def serving_default --tag_set serve --input_expr "x=np.ones(shape=(1,1), dtype=np.float)"
    CHECK_RESULT $? 0 0 "failed to run model"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset LD_LIBRARY_PATH
    test -f test.out && rm -rf ./test_out
    test -f saved_model_dir && rm -rf saved_model_dir
    test -f ./common/saved_model_keras_dir/ && rm -rf ./common/saved_model_keras_dir/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
