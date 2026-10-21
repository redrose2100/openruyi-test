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
# @Desc      :   test gresource command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    mkdir -p /tmp/gresource_test
    echo "test resource data" > /tmp/gresource_test/test_data.txt
    cat > /tmp/gresource_test/test.gresource.xml << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<gresources>
  <gresource prefix='/test'>
    <file>test_data.txt</file>
  </gresource>
</gresources>
EOF
    glib-compile-resources --target=/tmp/gresource_test/test.gresource --sourcedir=/tmp/gresource_test /tmp/gresource_test/test.gresource.xml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test help (only one help test)
    gresource help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gresource help check failed"
    
    # Test sections (list resource sections)
    gresource sections /tmp/gresource_test/test.gresource
    CHECK_RESULT $? 0 0 "gresource sections check failed"
    
    # Test list (list resources)
    gresource list /tmp/gresource_test/test.gresource | grep "/test/test_data.txt"
    CHECK_RESULT $? 0 0 "gresource list check failed"
    
    # Test details (list resources with details)
    gresource details /tmp/gresource_test/test.gresource | grep "[0-9] u"
    CHECK_RESULT $? 0 0 "gresource details check failed"
    
    # Test extract (extract a resource)
    gresource extract /tmp/gresource_test/test.gresource /test/test_data.txt | grep "test resource data"
    CHECK_RESULT $? 0 0 "gresource extract check failed"
    
    # Test --section
    gresource --section .data list /tmp/gresource_test/test.gresource | grep "/test/test_data.txt"
    CHECK_RESULT $? 0 0 "gresource --section check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/gresource_test
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"