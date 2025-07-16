#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.7.14
# @License   :   Mulan PSL v2
# @Desc      :   xmlwf formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch xmlwf_bad.xml
    cat > xmlwf_bad.xml << EOF
<root>
    <item>Test</item>
    <unclosed_tag>Error
</root>
EOF
    touch xmlwf_good.xml
    cat > xmlwf_good.xml << EOF
<root>
    <item>Test</item>
    <unclosed_tag>No Error</unclosed_tag>
</root>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    res1=$(xmlwf xmlwf_bad.xml)
    [ "$res1" == "xmlwf_bad.xml:4:2: mismatched tag" ]
    CHECK_RESULT $? 0 0 "xmlwf error"
    xmlwf xmlwf_good.xml
    CHECK_RESULT $? 0 0 "xmlwf error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f xmlwf_bad.xml xmlwf_good.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
