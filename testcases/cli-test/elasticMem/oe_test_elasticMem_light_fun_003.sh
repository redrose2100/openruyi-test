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
# @Desc      :   Verify memory_migration=true triggers memory migration
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_install_elasticmem || exit 255
    em_backup_config
    em_stop_service
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_light_config "[]" "true"
    em_start_service "light start failed"

    # start a 1GB memory process on NUMA0
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

    # wait for migration
    SLEEP_WAIT 30

    # check whether the process is assigned to a cgroup
    grep -q 'em_node' "/proc/$PID/cgroup" 2>/dev/null
    CHECK_RESULT $? 0 0 "process not in em_node cgroup"

    em_safe_kill "$PID"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    em_kill_bg
    em_stop_service
    em_restore_config
    em_dnf_remove
    em_remove_elasticmem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
