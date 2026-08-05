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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gtester-report command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    cat > /tmp/test_log.xml << 'EOF'
<?xml version="1.0"?>
<gtester>
  <info version="2.78.3"/>
  <testbinary path="/tmp/test_sample">
    <test-case path="/test/sample">
      <status>success</status>
      <duration>0.001</duration>
    </test-case>
  </testbinary>
</gtester>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test --help (only one help test)
    gtester-report --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gtester-report --help check failed"
    
    # Test --version
    gtester-report --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "gtester-report --version check failed"
    
    # Test basic usage (generate HTML report)
    gtester-report /tmp/test_log.xml | grep -i "html"
    CHECK_RESULT $? 0 0 "gtester-report basic check failed"
    
    # Test output contains test report title
    gtester-report /tmp/test_log.xml | grep "GTester Unit Test Report"
    CHECK_RESULT $? 0 0 "gtester-report report title check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_log.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"