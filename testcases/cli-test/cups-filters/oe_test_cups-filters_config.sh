#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2026/02/24
# @License   :   Mulan PSL v2
# @Desc      :   Test cups-filters configuration and tools
# ############################################
# shellcheck disable=SC2119,SC2230
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "cups-filters cups-filters-help"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    
    # 测试点1: 检查 cups-filters 关键文件存在性
    LOG_INFO "Test point 1: Check cups-filters key files existence"
    test -f /usr/lib/cups/filter/pdftops
    CHECK_RESULT $? 0 0 "pdftops filter does not exist"
    test -f /usr/lib/cups/filter/gstoraster
    CHECK_RESULT $? 0 0 "gstoraster filter does not exist"
    test -f /usr/lib/cups/filter/texttopdf
    CHECK_RESULT $? 0 0 "texttopdf filter does not exist"
    
    # 测试点2: 测试 cups-filters 工具基本功能
    LOG_INFO "Test point 2: Test cups-filters tools basic functions"
    # 检查 cupsfilter 命令功能
    which cupsfilter
    CHECK_RESULT $? 0 0 "cupsfilter command not found"
    # 测试 cupsfilter 处理文本文件
    echo "test" > /tmp/test.txt
    cupsfilter /tmp/test.txt 2>&1 | head -5
    CHECK_RESULT $? 0 0 "cupsfilter text processing failed"
    
    # 测试点3: 验证 cups-filters 配置和文档完整性
    LOG_INFO "Test point 3: Verify cups-filters configuration and documentation"
    test -f /etc/cups/cups-files.conf
    CHECK_RESULT $? 0 0 "cups-files.conf does not exist"
    # 检查 cups-filters 文档文件
    test -f /usr/share/doc/cups-filters/README
    CHECK_RESULT $? 0 0 "cups-filters README does not exist"
    # 检查 cups-filters 相关库文件
    test -f /usr/lib64/libcupsfilters.so.1
    CHECK_RESULT $? 0 0 "libcupsfilters.so.1 library does not exist"
    cupsfilter -o page-ranges=1 /tmp/test.txt > /tmp/out.pdf 2>/dev/null
    CHECK_RESULT $? 0 0 "cupsfilter -o parameter failed"
    cupsfilter -n 2 /tmp/test.txt > /tmp/out2.pdf 2>/dev/null
    CHECK_RESULT $? 0 0 "cupsfilter -n parameter failed"
    cupsfilter --list-filters /tmp/test.txt 2>&1 | grep -q "texttopdf"
    CHECK_RESULT $? 0 0 "cupsfilter --list-filters parameter failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f /tmp/test.txt /tmp/out.pdf /tmp/out2.pdf
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
