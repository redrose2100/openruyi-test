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
# @Date      :   2026/08/07
# @License   :   Mulan PSL v2
# @Desc      :   test gfs2_edit -p commands
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_edit_02.img"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gfs2-utils"
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=200
    LOOP_DEV=$(losetup -f --show "${TEST_IMG}")
    mkfs.gfs2 -O -p lock_nolock "${LOOP_DEV}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -p sb option (print superblock)
    gfs2_edit -p sb "${LOOP_DEV}" | grep -i "superblock"
    CHECK_RESULT $? 0 0 "gfs2_edit -p sb check failed"
    # Test -p size option (print filesystem size)
    gfs2_edit -p size "${LOOP_DEV}" | grep -i "size"
    CHECK_RESULT $? 0 0 "gfs2_edit -p size check failed"
    # Test -p master option (print master directory)
    gfs2_edit -p master "${LOOP_DEV}" | grep -i "master"
    CHECK_RESULT $? 0 0 "gfs2_edit -p master check failed"
    # Test -p root option (print root directory)
    gfs2_edit -p root "${LOOP_DEV}" | grep -i "root"
    CHECK_RESULT $? 0 0 "gfs2_edit -p root check failed"
    # Test -p jindex option (print journal index)
    gfs2_edit -p jindex "${LOOP_DEV}" | grep -i "Journal Index"
    CHECK_RESULT $? 0 0 "gfs2_edit -p jindex check failed"
    # Test -p per_node option (print per_node directory)
    gfs2_edit -p per_node "${LOOP_DEV}" | grep -i "Per-node"
    CHECK_RESULT $? 0 0 "gfs2_edit -p per_node check failed"
    # Test -p inum option (print inum file)
    gfs2_edit -p inum "${LOOP_DEV}" | grep -i "inum"
    CHECK_RESULT $? 0 0 "gfs2_edit -p inum check failed"
    # Test -p statfs option (print statfs file)
    gfs2_edit -p statfs "${LOOP_DEV}" | grep -i "statfs"
    CHECK_RESULT $? 0 0 "gfs2_edit -p statfs check failed"
    # Test -p rindex option (print rindex file)
    gfs2_edit -p rindex "${LOOP_DEV}" | grep -i "rindex"
    CHECK_RESULT $? 0 0 "gfs2_edit -p rindex check failed"
    # Test -p rgs option (print all resource groups)
    gfs2_edit -p rgs "${LOOP_DEV}" | grep -i "rg"
    CHECK_RESULT $? 0 0 "gfs2_edit -p rgs check failed"
    # Test -p quota option (print quota file)
    gfs2_edit -p quota "${LOOP_DEV}" | grep -i "quota"
    CHECK_RESULT $? 0 0 "gfs2_edit -p quota check failed"
    # Test -p <block> blocktype option (print block type)
    gfs2_edit -p 0x11 blocktype "${LOOP_DEV}" | grep -i "type"
    CHECK_RESULT $? 0 0 "gfs2_edit -p blocktype check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    losetup -d "${LOOP_DEV}"
    rm -rf "${TEST_IMG}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
