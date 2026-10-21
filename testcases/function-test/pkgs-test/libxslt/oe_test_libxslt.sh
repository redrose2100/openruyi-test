#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2023/02/23
# @License   :   Mulan PSL v2
# @Desc      :   Test libxslt use
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "libxslt"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rm -rf test.html
    xsltproc test.xslt test.xml > test.tmp 2>&1
    grep "UOS2" test.tmp
    CHECK_RESULT $? 0 0 "grep msg failed"
    xsltproc --output test.html test.xsl test.xml
    CHECK_RESULT $? 0 0 "xsltproc --output failed"
    ls -l test.html
    CHECK_RESULT $? 0 0 "output test.html failed"
    xsltproc --version
    CHECK_RESULT $? 0 0 "xsltproc --version failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.html test.tmp
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
