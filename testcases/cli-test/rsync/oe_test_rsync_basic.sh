#!/bin/bash
# 描述：rsync 基本功能测试（归档、排除、dry-run、校验、硬链接等）

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yuanjiafu
# @Contact   :   yuanjiafu@uniontech.com  
# @Date      :   2026-06-10
# @License   :   Mulan PSL v2
# @Desc      :   Test rsync basic features (archive, exclude, dry-run, checksum, link-dest)
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rsync
    # 创建测试源和目标目录
    mkdir -p /tmp/rsync_ext_src /tmp/rsync_ext_dst
    echo "extended test content" > /tmp/rsync_ext_src/test.txt
    mkdir -p /tmp/rsync_ext_src/nested
    echo "nested content" > /tmp/rsync_ext_src/nested/data.txt
}

function run_test() {
    LOG_INFO "Start testing rsync basic features."

    rsync -a /tmp/rsync_ext_src/ /tmp/rsync_ext_dst/
    CHECK_RESULT $? 0 0 "rsync archive mode sync failed"
    diff /tmp/rsync_ext_src/test.txt /tmp/rsync_ext_dst/test.txt
    CHECK_RESULT $? 0 0 "rsync synced test.txt content mismatch"

    rsync -a --exclude="nested" /tmp/rsync_ext_src/ /tmp/rsync_exclude_dst/
    CHECK_RESULT $? 0 0 "rsync with --exclude failed"
    test -d /tmp/rsync_exclude_dst/nested
    CHECK_RESULT $? 1 0 "rsync --exclude failed to exclude nested directory"

    rsync -av --dry-run /tmp/rsync_ext_src/ /tmp/rsync_dry_dst/ 2>&1 | grep -q "test.txt"
    CHECK_RESULT $? 0 0 "rsync --dry-run did not list test.txt"
    test -d /tmp/rsync_dry_dst
    CHECK_RESULT $? 1 0 "rsync --dry-run incorrectly created destination"

    rsync -ac /tmp/rsync_ext_src/ /tmp/rsync_checksum_dst/
    CHECK_RESULT $? 0 0 "rsync with --checksum failed"
    diff /tmp/rsync_ext_src/nested/data.txt /tmp/rsync_checksum_dst/nested/data.txt
    CHECK_RESULT $? 0 0 "rsync checksum synced nested file content mismatch"

    rsync -av --link-dest=/tmp/rsync_ext_dst /tmp/rsync_ext_src/ /tmp/rsync_link_dst/
    CHECK_RESULT $? 0 0 "rsync with --link-dest failed"
    diff /tmp/rsync_ext_src/test.txt /tmp/rsync_link_dst/test.txt
    CHECK_RESULT $? 0 0 "rsync link-dest synced file content mismatch"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/rsync_ext_src /tmp/rsync_ext_dst /tmp/rsync_exclude_dst
    rm -rf /tmp/rsync_dry_dst /tmp/rsync_checksum_dst /tmp/rsync_link_dst
    # shellcheck disable=SC2119
    DNF_REMOVE
}

main "$@"
