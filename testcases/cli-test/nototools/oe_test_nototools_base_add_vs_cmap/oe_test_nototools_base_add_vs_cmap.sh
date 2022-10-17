#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/10/10
# @License   :   Mulan PSL v2
# @Desc      :   TEST add_vs_cmap.py in nototools options
# #############################################

source "../common/common.sh"

# Preloaded data, parameter configuration
function config_params() {
    LOG_INFO "Start to config params of the case."
    
    TMP_DIR="/tmp/vs"

    LOG_INFO "End to config params of the case."
}

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    common_pre

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    add_vs_cmap.py -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    add_vs_cmap.py --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    # Test the -o,--output parameter
    add_vs_cmap.py -o "changename.ttf" font1.ttf && \
        fc-scan ${TMP_DIR}/changename.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -o error"
    rm -rf ${TMP_DIR}
    add_vs_cmap.py --output "changename.ttf" font1.ttf && \
        fc-scan ${TMP_DIR}/changename.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: --output error"
    rm -rf ${TMP_DIR}

    # Test the -s,--suffix parameter
    add_vs_cmap.py -s ".test" font1.ttf && \
        fc-scan ${TMP_DIR}/font1.test.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf ${TMP_DIR}
    add_vs_cmap.py --suffix ".test" font1.ttf && \
        fc-scan ${TMP_DIR}/font1.test.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: --suffix error"
    rm -rf ${TMP_DIR}

    #Test the -d,--dstdir parameter
    add_vs_cmap.py -d ${TMP_DIR}/test/ font1.ttf && \
        fc-scan ${TMP_DIR}/test/font1.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -d error"
    rm -rf ${TMP_DIR}
    add_vs_cmap.py --dstdir ${TMP_DIR}/test/ font1.ttf && \
        fc-scan ${TMP_DIR}/test/font1.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: --dstdir error"
    rm -rf ${TMP_DIR}

    # Test the -p,--presentation parameter
    for i in "emoji" "text"
    do
        add_vs_cmap.py -p ${i} font1.ttf && \
            fc-scan ${TMP_DIR}/font1.ttf | grep -q "Noto Sans"
        CHECK_RESULT $? 0 0 "option: -p ${i} error"
        rm -rf ${TMP_DIR}
        add_vs_cmap.py --presentation ${i} font1.ttf && \
            fc-scan ${TMP_DIR}/font1.ttf | grep -q "Noto Sans"
        CHECK_RESULT $? 0 0 "option: --presentation ${i} error"
        rm -rf ${TMP_DIR}
    done

    # Test the -vs,--vs_added parameter
    add_vs_cmap.py font1.ttf -vs 10 && \
        fc-scan ${TMP_DIR}/font1.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -vs error"
    rm -rf ${TMP_DIR}
    add_vs_cmap.py font1.ttf --vs_added 10 && \
        fc-scan ${TMP_DIR}/font1.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: --vs_added error"
    rm -rf ${TMP_DIR}
    
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ${TMP_DIR}
    common_post

    LOG_INFO "End to restore the test environment."
}

main "$@"