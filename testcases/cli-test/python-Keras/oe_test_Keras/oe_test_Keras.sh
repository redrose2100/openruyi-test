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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.3.29
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-Keras
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "python3-Keras"
    pip3 install tensorflow -i https://pypi.tuna.tsinghua.edu.cn/simple
    check_keras_version=$(python3 -c "import keras; print(keras.__version__)")
    LOG_INFO "keras_version:${check_keras_version}"
    KERAS_VERSION=${check_keras_version}
    VERSION_MAJOR=$(echo "${KERAS_VERSION}" | cut -d. -f1)
    VERSION_MINOR=$(echo "${KERAS_VERSION}" | cut -d. -f2)
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    python3 Keras_1.py > log1.txt
    CHECK_RESULT $? 0 0 "Keras_1.py failure"
    grep Epoch log1.txt
    CHECK_RESULT $? 0 0 "Functional model failure"
    if [ "$VERSION_MAJOR" -ge 2 ] && [ "$VERSION_MINOR" -ge 6 ]; then
        python3 Keras_3.py > log2.txt
    else
        python3 Keras_2.py > log2.txt
    fi
    CHECK_RESULT $? 0 0 "Keras_2.py failure"
    grep Epoch log2.txt
    CHECK_RESULT $? 0 0 "Serialization model failure"
}

function post_test() {
    DNF_REMOVE "$@"
    pip3 uninstall tensorflow -y
}

main "$@"



