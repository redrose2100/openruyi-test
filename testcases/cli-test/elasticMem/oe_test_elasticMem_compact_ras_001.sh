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
# @Desc      :   Verify compact_memory interaction
# #############################################

source "${OET_PATH}"/testcases/cli-test/elasticMem/common/em_common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || exit 255
    em_backup_config
    em_stop_service
    em_require_stress_ng
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_write_light_config "[]" "true"
    em_start_service "light start failed"

    # fragmentation workload
    numactl --cpunodebind=0 --membind=0 python3 -c '
import mmap, time
m = mmap.mmap(-1, 1073741824)
blk = b"x" * (1 << 20)
for o in range(0, 1073741824, 1 << 20):
    m[o:o+len(blk)] = blk
time.sleep(180)
' &
    local STRESS_PID
    STRESS_PID=$!
    em_track_pid "$STRESS_PID"
    kill -0 "$STRESS_PID"
    CHECK_RESULT $? 0 0 "fragmentation workload failed to start"
    SLEEP_WAIT 10

    # trigger compact_memory 3 times
    for i in 1 2 3; do
        echo 1 > /proc/sys/vm/compact_memory
        SLEEP_WAIT 5
        systemctl is-active "$SERVICE_NAME" --quiet
        CHECK_RESULT $? 0 0 "service died after compact_memory #$i"
    done

    em_safe_kill $STRESS_PID
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
