#!/usr/bin/bash

# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   dim measure test
# ##################################
# shellcheck disable=SC2002,SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    DNF_INSTALL "dim_tools dim vdo kmod-kvdo"
    lsmod | grep dim_core || insmod "$(rpm -ql dim | grep dim_core.ko)"
    lsmod | grep dim_monitor || insmod "$(rpm -ql dim | grep dim_monitor.ko)"
    depmod -a
    modprobe kvdo
}

function run_test() {
    LOG_INFO "Start to run test."

    xz -d /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko.xz
    mkdir -p /etc/dim/digest_list
    dim_gen_baseline /usr/bin/bash -o /etc/dim/digest_list/bash.hash
    CHECK_RESULT $? 0 0 "dim_gen_baseline failed."
    dim_gen_baseline /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko -o /etc/dim/digest_list/kvdo.hash
    CHECK_RESULT $? 0 0 "dim_gen_baseline failed."
    dim_gen_baseline -k "$(uname -r)" /boot/vmlinuz-"$(uname -r)" -o /etc/dim/digest_list/kernel.hash
    CHECK_RESULT $? 0 0 "dim_gen_baseline failed."

    echo "measure obj=BPRM_TEXT path=/usr/bin/bash" > /etc/dim/policy
    echo "measure obj=MODULE_TEXT name=kvdo" >> /etc/dim/policy
    echo "measure obj=KERNEL_TEXT" >> /etc/dim/policy
    echo 1 > /sys/kernel/security/dim/baseline_init
    CHECK_RESULT $? 0 0 "baseline_init failed."
    echo 1 > /sys/kernel/security/dim/measure
    CHECK_RESULT $? 0 0 "measure failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep /usr/bin/bash
    CHECK_RESULT $? 0 0 "get measure log failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep kvdo
    CHECK_RESULT $? 0 0 "get measure log failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep "$(uname -r)"
    CHECK_RESULT $? 0 0 "get measure log failed."
    cat /sys/kernel/security/dim/ascii_runtime_measurements | grep tampered
    CHECK_RESULT $? 0 1 "get measure log failed."

    echo 1 > /sys/kernel/security/dim/monitor_baseline
    CHECK_RESULT $? 0 0 "monitor_baseline failed."
    echo 1 > /sys/kernel/security/dim/monitor_run
    CHECK_RESULT $? 0 0 "monitor_run failed."
    cat /sys/kernel/security/dim/monitor_ascii_runtime_measurements | grep dim_core.text
    CHECK_RESULT $? 0 0 "get monitor log failed."
    cat /sys/kernel/security/dim/monitor_ascii_runtime_measurements | grep dim_core.data 
    CHECK_RESULT $? 0 0 "get monitor log failed."
    cat /sys/kernel/security/dim/monitor_ascii_runtime_measurements | grep tampered
    CHECK_RESULT $? 0 1 "get monitor log failed."

    LOG_INFO "End of the test."
}

function post_test() {
    rmmod dim_monitor dim_core kvdo
    rm /usr/lib/modules/"$(uname -r)"/kernel/drivers/block/kvdo.ko
    rm -rf /etc/dim/
    DNF_REMOVE "$@"
}

main "$@"

