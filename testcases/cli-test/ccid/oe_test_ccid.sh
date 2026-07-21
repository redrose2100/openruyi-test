#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/17
# @License   :   Mulan PSL v2
# @Desc      :   Test ccid driver files, metadata, dependencies and interfaces
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ccid binutils libxml2"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local ccid_driver="/usr/lib64/pcsc/drivers/ifd-ccid.bundle/Contents/Linux/libccid.so"
    local ccid_plist="/usr/lib64/pcsc/drivers/ifd-ccid.bundle/Contents/Info.plist"
    local serial_driver="/usr/lib64/pcsc/drivers/serial/libccidtwin.so"
    local serial_config="/etc/reader.conf.d/libccidtwin"


    test -f "${ccid_driver}" && test -f "${ccid_plist}" && test -f "${serial_driver}" && test -f "${serial_config}"
    CHECK_RESULT $? 0 0 "ccid package is missing required driver or configuration files"

    xmllint --noout "${ccid_plist}"
    CHECK_RESULT $? 0 0 "ccid Info.plist is not valid XML"

    grep -A1 "<key>CFBundleExecutable</key>" "${ccid_plist}" | grep -q "<string>libccid.so</string>"
    CHECK_RESULT $? 0 0 "ccid Info.plist does not reference libccid.so"

    grep -A1 "<key>ifdProductString</key>" "${ccid_plist}" | grep -q "<string>Generic CCID driver</string>"
    CHECK_RESULT $? 0 0 "ccid Info.plist does not contain the expected product description"

    ldd "${ccid_driver}" "${serial_driver}" 2>&1 | grep -q "not found"
    CHECK_RESULT $? 1 0 "ccid driver library has unresolved runtime dependencies"

    readelf --dyn-syms --wide "${ccid_driver}" | grep -q "IFDHCreateChannel"
    CHECK_RESULT $? 0 0 "libccid.so does not export IFDHCreateChannel"

    readelf --dyn-syms --wide "${ccid_driver}" | grep -q "IFDHTransmitToICC"
    CHECK_RESULT $? 0 0 "libccid.so does not export IFDHTransmitToICC"

    grep -Eq "^#LIBPATH[[:space:]]+/usr/lib64/pcsc/drivers/serial/libccidtwin.so$" "${serial_config}"
    CHECK_RESULT $? 0 0 "libccidtwin configuration does not reference the serial driver"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
