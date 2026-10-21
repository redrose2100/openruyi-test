#!/usr/bin/bash

#Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2026-01-14
# @License   :   Mulan PSL v2
# @Desc      :   Use librhsm case
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "GraphicsMagick"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gm convert -resize 50% common/test.jpg test_resized.jpg
    CHECK_RESULT $? 0 0 "Error, Fail to resize image"
    test -e test_resized.jpg
    CHECK_RESULT $? 0 0 "Error, resized image not created"
    gm convert -rotate 90 common/test.jpg test_rotated.jpg
    CHECK_RESULT $? 0 0 "Error, Fail to rotate image"
    test -e test_rotated.jpg
    CHECK_RESULT $? 0 0 "Error, rotated image not created"
    gm identify common/test.jpg
    CHECK_RESULT $? 0 0 "Error, Fail to identify image info"
    echo "create test1.jpg and test2.jpg for batch processing"
    cp common/test.jpg test1.jpg
    cp common/test.jpg test2.jpg
    gm mogrify -resize 200x200 test*.jpg
    CHECK_RESULT $? 0 0 "Error, Fail to batch process images"
    test -e test1.jpg && test -e test2.jpg
    CHECK_RESULT $? 0 0 "Error, batch processed images missing"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_resized.jpg test_rotated.jpg test1.jpg test2.jpg 2>/dev/null
    # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"

