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
# @Desc      :   test glib-compile-resources command
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_dir=/tmp/gresource_test
    xml_file=${test_dir}/test.gresource.xml
    glib-compile-resources --help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "glib-compile-resources --help check failed"

    # Test --version
    glib-compile-resources --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "glib-compile-resources --version check failed"

    # Test --target
    glib-compile-resources --sourcedir=${test_dir} --target=${test_dir}/test.gresource ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --target check failed"
    test -f ${test_dir}/test.gresource
    CHECK_RESULT $? 0 0 "glib-compile-resources --target output file check failed"

    # Test --sourcedir
    glib-compile-resources --sourcedir=${test_dir} --target=${test_dir}/test2.gresource ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --sourcedir check failed"
    test -f ${test_dir}/test2.gresource
    CHECK_RESULT $? 0 0 "glib-compile-resources --sourcedir output file check failed"

    # Test --generate
    glib-compile-resources --sourcedir=${test_dir} --generate --target=${test_dir}/test_gen.gresource ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate check failed"
    test -f ${test_dir}/test_gen.gresource
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate output file check failed"

    # Test --generate-header
    glib-compile-resources --sourcedir=${test_dir} --generate-header --target=${test_dir}/test.h ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-header check failed"
    grep -q "RESOURCE_test_H" ${test_dir}/test.h
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-header content check failed"

    # Test --generate-source
    glib-compile-resources --sourcedir=${test_dir} --generate-source --target=${test_dir}/test.c ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-source check failed"
    grep -q "gio/gio.h" ${test_dir}/test.c
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-source content check failed"

    # Test --generate-dependencies
    glib-compile-resources --sourcedir=${test_dir} --generate-dependencies ${xml_file} | grep "test_data.txt"
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-dependencies check failed"

    # Test --dependency-file
    glib-compile-resources --sourcedir=${test_dir} --dependency-file=${test_dir}/test.dep --generate-dependencies ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --dependency-file check failed"
    grep -q "test_data.txt" ${test_dir}/test.dep
    CHECK_RESULT $? 0 0 "glib-compile-resources --dependency-file content check failed"

    # Test --generate-phony-targets
    glib-compile-resources --sourcedir=${test_dir} --generate-phony-targets --dependency-file=${test_dir}/test_phony.dep ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-phony-targets check failed"
    grep -q "test_data.txt" ${test_dir}/test_phony.dep
    CHECK_RESULT $? 0 0 "glib-compile-resources --generate-phony-targets content check failed"

    # Test --manual-register
    glib-compile-resources --sourcedir=${test_dir} --manual-register --generate-header --target=${test_dir}/test_manual.h ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --manual-register check failed"
    grep -q "test_register_resource" ${test_dir}/test_manual.h
    CHECK_RESULT $? 0 0 "glib-compile-resources --manual-register content check failed"

    # Test --internal
    glib-compile-resources --sourcedir=${test_dir} --internal --generate-header --target=${test_dir}/test_internal.h ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --internal check failed"
    grep -q "G_GNUC_INTERNAL" ${test_dir}/test_internal.h
    CHECK_RESULT $? 0 0 "glib-compile-resources --internal content check failed"

    # Test --external-data
    glib-compile-resources --sourcedir=${test_dir} --external-data --generate-source --target=${test_dir}/test_ext.c ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --external-data check failed"
    grep -q "extern" ${test_dir}/test_ext.c
    CHECK_RESULT $? 0 0 "glib-compile-resources --external-data content check failed"

    # Test --c-name
    glib-compile-resources --sourcedir=${test_dir} --c-name MyResource --generate-header --target=${test_dir}/test_cname.h ${xml_file}
    CHECK_RESULT $? 0 0 "glib-compile-resources --c-name check failed"
    grep -q "MyResource_get_resource" ${test_dir}/test_cname.h
    CHECK_RESULT $? 0 0 "glib-compile-resources --c-name content check failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    export LANG=$OLD_LANG
    rm -rf /tmp/gresource_test
    LOG_INFO "End to restore the test environment."
}

main "$@"
