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
# @Author    :   xu_yishen
# @Contact   :   xuyishen3@huawei.com
# @Date      :   2026/06/30
# @License   :   Mulan PSL v2
# @Desc      :   Verify memory_migration=false does not migrate memory
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_light_config "[]" "false"
    em_start_service "light start failed"

    # start a memory process on NUMA0
    numactl --cpunodebind=0 --membind=0 python3 -c '
import mmap, time, sys
m = mmap.mmap(-1, int(sys.argv[1]))
blk = b"x" * (1 << 20)
for o in range(0, int(sys.argv[1]), 1 << 20):
    m[o:o+len(blk)] = blk
time.sleep(int(sys.argv[2]))
' 1073741824 180 &
    local PID
    PID=$!
    em_track_pid "$PID"
    kill -0 "$PID"
    CHECK_RESULT $? 0 0 "memory load process failed to start"
    SLEEP_WAIT 20

    SLEEP_WAIT 30

    # with migration=false, the log should have no migrate record
    em_assert_not_log_contains "MigratePages" "migration log found when migration=false"

    em_safe_kill "$PID"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
