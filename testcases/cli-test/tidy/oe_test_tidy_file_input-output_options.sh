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
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/2/6
# @License   :   Mulan PSL v2
# @Desc      :   Test iftop text mode
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tidy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # --error-file
    # 将错误和警告写入指定文件
    echo '' | tidy --error-file ./errors_and_warnings
    cat ./errors_and_warnings | grep 'Warning'
    echo 'error-file: true' > ./tidyrc
    echo '' | tidy -config ./tidyrc
    cat ./errors_and_warnings | grep 'Warning'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: error-file"
    # --keep-time
    # 保留源文件的最新修改时间
    echo 'hi' > ./sample.html
    original_modification_time="$(stat --format "%y" ./sample.html)"
    tidy --keep-time true -o ./sample.html
    current_modification_time="$(stat --format "%y" ./sample.html)"
    [ "${original_modification_time}" = "${current_modification_time}" ]
    CHECK_RESULT $? 0 0 "Failed to use option: --keep-time"
    echo 'keep-time: true' > ./tidyrc
    tidy -config ./tidyrc -o ./sample.html
    current_modification_time="$(stat --format "%y" ./sample.html)"
    [ "${original_modification_time}" = "${current_modification_time}" ]
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: keep-time"
    # --output-file
    # 将处理结果（标记语言代码）写入指定文件
    echo '<h1>hi' | tidy --output-file ./sample.html
    cat ./sample.html | grep '<h1>hi</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option: --output-file"
    echo 'output-file: sample.html' > ./tidyrc
    echo '' | tidy -config ./tidyrc
    cat ./sample.html | grep '<h1>hi</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-file"
    # --write-back
    # 指定是否将处理后的结果写回源文件
    echo '<h1>hi' > ./sample.html
    tidy --write-back true ./sample.html
    cat ./sample.html | grep '<h1>hi</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option: --write-back"
    echo '<h1>hi' > ./sample.html
    echo 'write-back: true' > ./tidyrc
    tidy -config ./tidyrc ./sample.html
    cat ./sample.html | grep '<h1>hi</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: write-back"
    LOG_INFO "Finish test!"
} 

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -f ./tidyrc
    rm -f ./sample.html
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
