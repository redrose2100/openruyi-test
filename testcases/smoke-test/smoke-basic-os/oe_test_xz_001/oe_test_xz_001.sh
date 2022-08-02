#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengwenzhe
# @Contact   :   chengwenzhe@uniontech.com
# @Date      :   2022-08-02
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-xz
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    echo "hello, xz!" > /tmp/test_xz.txt

	xz -z  /tmp/test_xz.txt
	CHECK_RESULT $? 0 0 "xz compress error"

	test -f /tmp/test_xz.txt.xz
	CHECK_RESULT $? 0 0 "test_ Xz.txt.xz not generated"

	xzcat /tmp/test_xz.txt.xz | grep "hello, xz!"
    CHECK_RESULT $? 0 0 "xzcat error"

    xz -d /tmp/test_xz.txt.xz
    CHECK_RESULT $? 0 0 "xz -d decompression error"

    xz /tmp/test_xz.txt
    unxz /tmp/test_xz.txt.xz
    CHECK_RESULT $? 0 0 "unxz decompression error"

}

main $@