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
# @Desc      :   test glib-compile-schemas command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL glib2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    mkdir -p /tmp/test_schemas /tmp/test_schemas_out
    cat > /tmp/test_schemas/org.test.gschema.xml << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<schemalist>
  <schema id='org.test.schema' path='/org/test/schema/'>
    <key name='test-key' type='s'>
      <default>'hello'</default>
      <summary>Test key</summary>
      <description>A test key for testing</description>
    </key>
  </schema>
</schemalist>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    glib-compile-schemas --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "glib-compile-schemas --help check failed"
    
    glib-compile-schemas --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "glib-compile-schemas --version check failed"
    
    # Test --targetdir
    glib-compile-schemas --targetdir=/tmp/test_schemas_out /tmp/test_schemas
    CHECK_RESULT $? 0 0 "glib-compile-schemas --targetdir check failed"
    grep -c "org.test.schema" /tmp/test_schemas_out/gschemas.compiled
    CHECK_RESULT $? 0 0 "glib-compile-schemas --targetdir content check failed"
    
    # Test --dry-run (should not write output file)
    rm -f /tmp/test_schemas_out/gschemas_dryrun.compiled
    glib-compile-schemas --dry-run /tmp/test_schemas
    CHECK_RESULT $? 0 0 "glib-compile-schemas --dry-run check failed"
    
    # Test --strict
    glib-compile-schemas --strict --targetdir=/tmp/test_schemas_out /tmp/test_schemas
    CHECK_RESULT $? 0 0 "glib-compile-schemas --strict check failed"
    grep -c "org.test.schema" /tmp/test_schemas_out/gschemas.compiled
    CHECK_RESULT $? 0 0 "glib-compile-schemas --strict content check failed"
    
    # Test --allow-any-name
    glib-compile-schemas --allow-any-name --targetdir=/tmp/test_schemas_out /tmp/test_schemas
    CHECK_RESULT $? 0 0 "glib-compile-schemas --allow-any-name check failed"
    grep -c "test-key" /tmp/test_schemas_out/gschemas.compiled
    CHECK_RESULT $? 0 0 "glib-compile-schemas --allow-any-name content check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    export LANG=$OLD_LANG
    rm -rf /tmp/test_schemas /tmp/test_schemas_out
    LOG_INFO "End to restore the test environment."
}

main "$@"
