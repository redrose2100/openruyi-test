#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-06
# @License   :   Mulan PSL v2
# @Desc      :   Test hwdata package installation completeness and hardware ID query
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwdata pciutils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test hwdata_install: Verify hwdata package is installed
    rpm -q hwdata > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "hwdata package not installed"

    # Query package info once for all field validations
    hwdata_info=$(rpm -qi hwdata 2>/dev/null)

    # Test hwdata_version: Verify version field exists and has valid format
    echo "$hwdata_info" | grep "^Version" | grep -E "[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "hwdata version invalid"

    # Test hwdata_release: Verify release field exists
    echo "$hwdata_info" | grep "^Release"
    CHECK_RESULT $? 0 0 "hwdata release not found"

    # Test hwdata_arch: Verify architecture field exists
    echo "$hwdata_info" | grep "^Architecture"
    CHECK_RESULT $? 0 0 "hwdata architecture not found"

    # Test hwdata_license: Verify license field exists
    echo "$hwdata_info" | grep "^License"
    CHECK_RESULT $? 0 0 "hwdata license not found"

    # Test hwdata_summary: Check hwdata package summary
    rpm -q hwdata --qf "%{SUMMARY}" 2>/dev/null | grep -qi "hardware\|hwdata"
    CHECK_RESULT $? 0 0 "hwdata summary not found or invalid"

    # Test hwdata_pci_ids_file: Verify pci.ids file exists
    [ -f /usr/share/hwdata/pci.ids ]
    CHECK_RESULT $? 0 0 "pci.ids file not found"

    # Test hwdata_usb_ids_file: Verify usb.ids file exists
    [ -f /usr/share/hwdata/usb.ids ]
    CHECK_RESULT $? 0 0 "usb.ids file not found"

    # Test hwdata_pnp_ids_file: Verify pnp.ids file exists
    [ -f /usr/share/hwdata/pnp.ids ]
    CHECK_RESULT $? 0 0 "pnp.ids file not found"

    # Test hwdata_iab_txt_file: Verify iab.txt file exists
    [ -f /usr/share/hwdata/iab.txt ]
    CHECK_RESULT $? 0 0 "iab.txt file not found"

    # Test hwdata_oui_txt_file: Verify oui.txt file exists
    [ -f /usr/share/hwdata/oui.txt ]
    CHECK_RESULT $? 0 0 "oui.txt file not found"

    # Test hwdata_blacklist_file: Verify dist-blacklist.conf file exists
    [ -f /usr/lib/modprobe.d/dist-blacklist.conf ]
    CHECK_RESULT $? 0 0 "dist-blacklist.conf file not found"

    # Test hwdata_pc_file: Verify pkgconfig file exists
    [ -f /usr/share/pkgconfig/hwdata.pc ]
    CHECK_RESULT $? 0 0 "hwdata.pc file not found"

    # Test hwdata_pci_count: Verify pci.ids has sufficient entries
    [ "$(grep -c "^[0-9a-fA-F]\{4\}" /usr/share/hwdata/pci.ids 2>/dev/null)" -gt 100 ]
    CHECK_RESULT $? 0 0 "pci.ids entries insufficient"

    # Test hwdata_usb_count: Verify usb.ids has sufficient entries
    [ "$(grep -c "^[0-9a-fA-F]\{4\}" /usr/share/hwdata/usb.ids 2>/dev/null)" -gt 100 ]
    CHECK_RESULT $? 0 0 "usb.ids entries insufficient"

    # Test hwdata_oui_count: Verify oui.txt has sufficient entries
    [ "$(grep -c "^[0-9A-F]\{2\}-[0-9A-F]\{2\}-[0-9A-F]\{2\}" /usr/share/hwdata/oui.txt 2>/dev/null)" -gt 100 ]
    CHECK_RESULT $? 0 0 "oui.txt entries insufficient"

    # Test hwdata_pci_query: Query PCI vendor by ID 001c and verify name
    grep "^001c " /usr/share/hwdata/pci.ids | grep -i "PEAK" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "PCI ID 001c vendor query failed"

    # Test hwdata_usb_query: Query USB vendor by ID 0001 and verify name
    grep "^0001 " /usr/share/hwdata/usb.ids | grep -i "Fry" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "USB ID 0001 vendor query failed"

    # Test hwdata_pnp_query: Query PnP vendor by ID AAA and verify name
    grep "^AAA[[:space:]]" /usr/share/hwdata/pnp.ids | grep -i "Avolites" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "PnP ID AAA vendor query failed"

    # Test hwdata_mac_query: Query MAC prefix 08-9C-86 and verify organization
    grep -E "08-9C-86" /usr/share/hwdata/oui.txt | grep -i "Nokia" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "MAC prefix 08-9C-86 organization query failed"

    # Test hwdata_lspci_integration: Verify lspci uses hwdata to show vendor name
    lspci 2>/dev/null | grep -qi "QEMU\|Red Hat\|Intel" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "lspci failed to show vendor names from hwdata"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
