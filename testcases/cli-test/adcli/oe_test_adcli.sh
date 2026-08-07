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
# @Date      :   2026-08-07
# @License   :   Mulan PSL v2
# @Desc      :   Test adcli package installation and command functionality
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "adcli"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test adcli_install: Verify adcli package is installed
    rpm -q adcli > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "adcli package not installed"

    # Query package info once for all field validations
    adcli_info=$(rpm -qi adcli 2>/dev/null)

    # Test adcli_version: Verify version field has valid format
    echo "$adcli_info" | grep "^Version" | grep -E "[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "adcli version invalid"

    # Test adcli_release: Verify release field has valid format
    echo "$adcli_info" | grep "^Release" | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "adcli release invalid"

    # Test adcli_arch: Verify architecture is aarch64 or x86_64
    echo "$adcli_info" | grep "^Architecture" | grep -E "aarch64|x86_64"
    CHECK_RESULT $? 0 0 "adcli architecture invalid"

    # Test adcli_license: Verify license field contains LGPL
    echo "$adcli_info" | grep "^License" | grep -i "LGPL"
    CHECK_RESULT $? 0 0 "adcli license should contain LGPL"

    # Test adcli_summary: Verify summary contains Active Directory keyword
    echo "$adcli_info" | grep "^Summary" | grep -i "Active Directory"
    CHECK_RESULT $? 0 0 "adcli summary should contain Active Directory"

    # Test adcli_url: Verify URL field points to realmd/adcli
    echo "$adcli_info" | grep "^URL" | grep -i "realmd\|adcli"
    CHECK_RESULT $? 0 0 "adcli URL should contain realmd or adcli"

    # Test adcli_files: Verify package files exist
    [ "$(rpm -ql adcli 2>/dev/null | wc -l)" -gt 0 ]
    CHECK_RESULT $? 0 0 "adcli package files missing"

    # Test adcli_binary: Verify adcli binary exists and is executable
    [ -x /usr/sbin/adcli ]
    CHECK_RESULT $? 0 0 "adcli binary not found or not executable"

    # Test adcli_doc: Verify ChangeLog documentation file exists
    [ -f /usr/share/doc/adcli/ChangeLog ]
    CHECK_RESULT $? 0 0 "adcli ChangeLog not found"

    # Test adcli_license_file: Verify COPYING license file exists
    [ -f /usr/share/licenses/adcli/COPYING ]
    CHECK_RESULT $? 0 0 "adcli COPYING file not found"

    # Test adcli_authors_file: Verify AUTHORS file exists
    [ -f /usr/share/licenses/adcli/AUTHORS ]
    CHECK_RESULT $? 0 0 "adcli AUTHORS file not found"

    # Test adcli_help: Verify adcli --help displays usage and subcommands
    adcli --help 2>&1 | grep "usage: adcli command"
    CHECK_RESULT $? 0 0 "adcli --help failed"
    adcli --help 2>&1 | grep "info.*Print information about a domain"
    CHECK_RESULT $? 0 0 "adcli subcommand info not found"
    adcli --help 2>&1 | grep "join.*Join this machine to a domain"
    CHECK_RESULT $? 0 0 "adcli subcommand join not found"
    adcli --help 2>&1 | grep "testjoin.*Test if machine account password is valid"
    CHECK_RESULT $? 0 0 "adcli subcommand testjoin not found"

    # Test adcli_info_no_domain: Verify adcli info without domain reports error
    adcli info 2>&1 | grep "specify a domain"
    CHECK_RESULT $? 0 0 "adcli info without domain should report error"

    # Test adcli_info_invalid_domain: Verify adcli info with invalid domain fails gracefully
    adcli info invalid.example 2>&1 | grep -i "couldn't discover\|discover"
    CHECK_RESULT $? 0 0 "adcli info with invalid domain should report error"

    # Test adcli_join_no_domain: Verify adcli join without domain reports error
    adcli join 2>&1 | grep -i "domain\|specify"
    CHECK_RESULT $? 0 0 "adcli join without domain should report error"

    # Test adcli_testjoin_no_keytab: Verify adcli testjoin fails gracefully without domain join
    adcli testjoin 2>&1 | grep -i "domain\|keytab\|fail\|error\|not"
    CHECK_RESULT $? 0 0 "adcli testjoin without join should report error"

    # Test adcli_invalid_command: Verify adcli with invalid command reports error
    adcli invalidcmd 2>&1 | grep -i "usage\|invalid\|unknown\|command"
    CHECK_RESULT $? 0 0 "adcli invalid command should report error"

    # Test adcli_ldd_krb5: Verify adcli links to krb5 library
    ldd /usr/sbin/adcli 2>/dev/null | grep "libkrb5"
    CHECK_RESULT $? 0 0 "adcli not linked to libkrb5"

    # Test adcli_ldd_gssapi: Verify adcli links to gssapi_krb5 library
    ldd /usr/sbin/adcli 2>/dev/null | grep "libgssapi_krb5"
    CHECK_RESULT $? 0 0 "adcli not linked to libgssapi_krb5"

    # Test adcli_ldd_ldap: Verify adcli links to ldap library
    ldd /usr/sbin/adcli 2>/dev/null | grep "libldap"
    CHECK_RESULT $? 0 0 "adcli not linked to libldap"

    # Test adcli_ldd_sasl: Verify adcli links to sasl library
    ldd /usr/sbin/adcli 2>/dev/null | grep "libsasl2"
    CHECK_RESULT $? 0 0 "adcli not linked to libsasl2"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
