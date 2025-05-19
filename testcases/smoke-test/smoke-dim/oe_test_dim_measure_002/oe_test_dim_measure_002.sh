#!/usr/bin/bash

# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199711@126.com
# @Date      :   2023/10/12
# @Desc      :   dim measure tampered test
# ##################################
# shellcheck disable=SC2002,SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    DNF_INSTALL "dim_tools dim vdo kmod-kvdo"
    lsmod | grep dim_core || insmod "$(rpm -ql dim | grep dim_core.ko)"
    lsmod | grep dim_monitor || insmod "$(rpm -ql dim | grep dim_monitor.ko)"
}

function run_test() {
    LOG_INFO "Start to run test."

    xz -d /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko.xz
    gcc ../common/proc/dim_proc.c -o dim_proc 
    gcc ../common/proc/dim_proc_new.c -o dim_proc_new
    make -C /lib/modules/"$(uname -r)"/build M="$(pwd)"/../common/module modules

    mkdir -p /etc/dim/digest_list
    dim_gen_baseline dim_proc -o /etc/dim/digest_list/dim_proc.hash
    dim_gen_baseline /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko -o /etc/dim/digest_list/kvdo.hash
    echo "measure obj=BPRM_TEXT path=$(pwd)/dim_proc" > /etc/dim/policy
    echo "measure obj=MODULE_TEXT name=kvdo" >> /etc/dim/policy

    ./dim_proc &
    depmod -a
    modprobe kvdo
    echo 1 > /sys/kernel/security/dim/baseline_init
    CHECK_RESULT $? 0 0 "baseline_init failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep tampered
    CHECK_RESULT $? 0 1 "get measure log failed."
    echo 1 > /sys/kernel/security/dim/monitor_baseline
    CHECK_RESULT $? 0 0 "monitor_baseline failed."
    echo 1 > /sys/kernel/security/dim/monitor_run
    CHECK_RESULT $? 0 0 "monitor_run failed."
    cat /sys/kernel/security/dim/monitor_ascii_runtime_measurements | grep tampered
    CHECK_RESULT $? 0 1 "get monitor log failed."

    pkill -9 dim_proc
    rmmod kvdo
    mv dim_proc_new dim_proc
    ./dim_proc &
    insmod ../common/module/kvdo.ko

    echo 1 > /sys/kernel/security/dim/measure
    CHECK_RESULT $? 0 0 "measure failed." 
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep tampered | grep kvdo
    CHECK_RESULT $? 0 0 "get measure log failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep tampered | grep dim_proc
    CHECK_RESULT $? 0 0 "get measure log failed."

    echo "measure obj=BPRM_TEXT path=/usr/bin/bash" > /etc/dim/policy
    echo 1 > /sys/kernel/security/dim/baseline_init
    CHECK_RESULT $? 0 0 "baseline_init failed."
    echo 1 > /sys/kernel/security/dim/monitor_run
    CHECK_RESULT $? 0 0 "monitor_run failed."
    cat /sys/kernel/security/dim/monitor_ascii_runtime_measurements | grep tampered
    CHECK_RESULT $? 0 0 "get monitor log failed."

    LOG_INFO "End of the test."
}

function post_test() {
    DNF_REMOVE "$@"
    pkill -9 dim_proc
    rmmod kvdo dim_monitor dim_core
    rm /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko
    rm -rf /etc/dim/
    make -C /lib/modules/"$(uname -r)"/build M="$(pwd)"/../common/module clean
    rm -rf dim_proc*
}

main "$@"

