#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run squashfs-tools testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    mksquashfs ./boot.img squashtest.squashfs && test -f squashtest.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs fail"
    mksquashfs ./boot.img squashtest1.squashfs -comp xz && test -f squashtest1.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs -comp xz fail"
    mksquashfs ./boot.img squashtest2.squashfs -b 1M && test -f squashtest2.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs -b 1M fail"
    mksquashfs ./boot.img squashtest3.squashfs -reproducible && test -f squashtest3.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs -reproducible fail"
    mksquashfs ./boot.img squashtest4.squashfs -tarstyle && test -f squashtest4.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs -tarstyle fail"
    mksquashfs ./boot.img squashtest5.squashfs -exports && test -f squashtest5.squashfs
    CHECK_RESULT $? 0 0 "check mksquashfs -exports fail"

    unsquashfs squashtest.squashfs && test -d squashfs-root && rm -rf squashfs-root
    CHECK_RESULT $? 0 0 "check unsquashfs fail"
    unsquashfs -d /tmp/test_unsquashfs squashtest.squashfs && test -d /tmp/test_unsquashfs
    CHECK_RESULT $? 0 0 "check unsquashfs -d fail"
    unsquashfs -q squashtest.squashfs | grep -v "unsquashfs:"
    CHECK_RESULT $? 0 0 "check unsquashfs -q fail"
    unsquashfs -f squashtest.squashfs && test -d squashfs-root && rm -rf squashfs-root
    CHECK_RESULT $? 0 0 "check unsquashfs -f fail"
    unsquashfs -excludes squashtest.squashfs | grep "1 inodes" && rm -rf squashfs-root
    CHECK_RESULT $? 0 0 "check unsquashfs -excludes fail"
    unsquashfs -n squashtest.squashfs && test -d squashfs-root && rm -rf squashfs-root
    CHECK_RESULT $? 0 0 "check unsquashfs -n fail"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf squashtest*.squashfs squashfs-root /tmp/test_unsquashfs

    LOG_INFO "End to restore the test environment."
}

main "$@"
