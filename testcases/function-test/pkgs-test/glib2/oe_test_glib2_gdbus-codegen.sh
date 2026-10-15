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
# @Desc      :   test gdbus-codegen command
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    
    # Create test D-Bus introspection XML file
    cat > /tmp/test_dbus_codegen.xml << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE node PUBLIC '-//freedesktop//DTD D-BUS Object Introspection 1.0//EN'
  'http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd'>
<node name='/org/freedesktop/test'>
  <interface name='org.freedesktop.test.Interface'>
    <method name='Method1'>
      <arg type='s' name='input' direction='in'/>
      <arg type='s' name='output' direction='out'/>
    </method>
    <signal name='Signal1'>
      <arg type='s' name='param'/>
    </signal>
    <property name='Property1' type='s' access='read'/>
  </interface>
</node>
EOF
    
    mkdir -p /tmp/test_codegen_out
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test --help
    gdbus-codegen --help | grep -i "usage"
    CHECK_RESULT $? 0 0 "gdbus-codegen --help check failed"
    
    # Test --interface-prefix
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_prefix --interface-prefix org.freedesktop /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-prefix check failed"
    grep -q "TestInterface" /tmp/test_codegen_out/test_prefix.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-prefix content check failed"
    
    # Test --c-namespace
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_ns --c-namespace TestNS /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-namespace check failed"
    grep -q "TestNS" /tmp/test_codegen_out/test_ns.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-namespace content check failed"
    
    # Test --c-generate-object-manager
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_objmgr --c-generate-object-manager /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-object-manager check failed"
    grep -q "ObjectManagerClient" /tmp/test_codegen_out/test_objmgr.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-object-manager content check failed"
    
    # Test --c-generate-autocleanup
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_acleanup --c-generate-autocleanup objects /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-autocleanup check failed"
    grep -q "G_DEFINE_AUTOPTR_CLEANUP_FUNC" /tmp/test_codegen_out/test_acleanup.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-autocleanup content check failed"
    
    # Test --generate-docbook
    gdbus-codegen --generate-docbook /tmp/test_codegen_out/test_doc /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --generate-docbook check failed"
    grep -q "DOCTYPE refentry" /tmp/test_codegen_out/test_doc-org.freedesktop.test.Interface.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --generate-docbook content check failed"
    
    if gdbus-codegen -h | grep "generate-md";then
        # Test --generate-md
        gdbus-codegen --generate-md /tmp/test_codegen_out/test_md /tmp/test_dbus_codegen.xml
        CHECK_RESULT $? 0 0 "gdbus-codegen --generate-md check failed"
        grep -q "# org.freedesktop.test.Interface" /tmp/test_codegen_out/test_md-org.freedesktop.test.Interface.md
        CHECK_RESULT $? 0 0 "gdbus-codegen --generate-md content check failed"
    fi
    
    if gdbus-codegen -h | grep "generate-rst";then
        # Test --generate-rst
        gdbus-codegen --generate-rst /tmp/test_codegen_out/test_rst /tmp/test_dbus_codegen.xml
        CHECK_RESULT $? 0 0 "gdbus-codegen --generate-rst check failed"
        grep -q "===" /tmp/test_codegen_out/test_rst-org.freedesktop.test.Interface.rst
        CHECK_RESULT $? 0 0 "gdbus-codegen --generate-rst content check failed"
    fi
    
    # Test --pragma-once
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_pragma --pragma-once /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --pragma-once check failed"
    grep -q "#pragma once" /tmp/test_codegen_out/test_pragma.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --pragma-once content check failed"
    
    # Test --annotate
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_annotate --annotate org.freedesktop.test.Interface GType None /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --annotate check failed"
    grep -q "GType" /tmp/test_codegen_out/test_annotate.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --annotate content check failed"
    
    # Test --glib-min-required
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_minver --glib-min-required 2.50 /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --glib-min-required check failed"
    test -f /tmp/test_codegen_out/test_minver.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --glib-min-required output file check failed"
    
    # Test --glib-max-allowed
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_maxver --glib-max-allowed 2.80 /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --glib-max-allowed check failed"
    test -f /tmp/test_codegen_out/test_maxver.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --glib-max-allowed output file check failed"
    
    # Test --symbol-decorator
    gdbus-codegen --generate-c-code /tmp/test_codegen_out/test_decorator --symbol-decorator G_BUS_API /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --symbol-decorator check failed"
    grep -q "G_BUS_API" /tmp/test_codegen_out/test_decorator.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --symbol-decorator content check failed"
    
    # Test --header with --output
    gdbus-codegen --header --output /tmp/test_codegen_out/test_header.h /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --header check failed"
    grep -q "#ifndef" /tmp/test_codegen_out/test_header.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --header content check failed"
    
    # Test --body with --output
    gdbus-codegen --body --output /tmp/test_codegen_out/test_body.c /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --body check failed"
    grep -q "#ifdef HAVE_CONFIG_H" /tmp/test_codegen_out/test_body.c
    CHECK_RESULT $? 0 0 "gdbus-codegen --body content check failed"
    
    # Test --interface-info-header with --output
    gdbus-codegen --interface-info-header --output /tmp/test_codegen_out/test_iface_info.h /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-info-header check failed"
    grep -q "GDBusInterfaceInfo" /tmp/test_codegen_out/test_iface_info.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-info-header content check failed"
    
    # Test --interface-info-body with --output
    gdbus-codegen --interface-info-body --output /tmp/test_codegen_out/test_iface_info.c /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-info-body check failed"
    grep -q "GDBusMethodInfo" /tmp/test_codegen_out/test_iface_info.c
    CHECK_RESULT $? 0 0 "gdbus-codegen --interface-info-body content check failed"
    
    # Test --output-directory
    gdbus-codegen --generate-c-code test_out --output-directory /tmp/test_codegen_out /tmp/test_dbus_codegen.xml
    CHECK_RESULT $? 0 0 "gdbus-codegen --output-directory check failed"
    grep -q "TEST_OUT" /tmp/test_codegen_out/test_out.h
    CHECK_RESULT $? 0 0 "gdbus-codegen --output-directory content check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/test_codegen_out /tmp/test_dbus_codegen.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
