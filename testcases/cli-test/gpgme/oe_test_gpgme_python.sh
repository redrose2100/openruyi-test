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
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-17
# @License   :   Mulan PSL v2
# @Desc      :   gpgme Python bindings test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-gpgme"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Verify python3-gpgme package is installed
    rpm -qa | grep -w python3-gpgme
    CHECK_RESULT $? 0 0 "python3-gpgme package not installed"
    
    # Step 2: Test Python import
    python3 -c "import gpg; print('gpg module imported successfully')"
    CHECK_RESULT $? 0 0 "Failed to import gpg module"
    
    # Step 3: Test gpgme version via gpg.version submodule
    python3 -c "import gpg.version; print('gpgme version:', gpg.version.versionstr)"
    CHECK_RESULT $? 0 0 "Failed to get gpgme version"
    
    # Step 4: Test gpgme context creation
    python3 -c "
import gpg
ctx = gpg.Context()
print('Context created successfully')
print('Protocol:', ctx.protocol)
"
    CHECK_RESULT $? 0 0 "Failed to create gpgme context"
    
    # Step 5: Test gpgme version components
    python3 -c "import gpg.version; print('Major:', gpg.version.major, 'Minor:', gpg.version.minor, 'Patch:', gpg.version.patch)"
    CHECK_RESULT $? 0 0 "Failed to get gpgme version components"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"