# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yuanlulu
# @Contact   :   1297248816@qq.com
# @Date      :   2023/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test nvwa when redis run
# #############################################
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162,SC2119
source ${OET_PATH}/testcases/function-test/pkgs-test/nvwa/common/lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! dnf list --quiet nvwa 2>/dev/null | grep -q '^nvwa\.'; then
       LOG_ERROR "未找到 nvwa 软件包，退出码 255"
       exit 255
    fi
    deploy_nvwa
    #判断系统是否支持NVWA quickkexec
    if grep -q "CONFIG_QUICK_KEXEC=y" /boot/config-"$(uname -r)" 2>/dev/null; then
       deploy_nvwwa_with_conf
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    last_reboot=$(SSH_CMD "last reboot | head -1 | awk '{print \$8}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -1 | sed 's/\r//')
    deploy_redis 1
    start_redis 1
    pids=$(get_process_pid redis)
    modify_nvwa_restore_by_pid "${pids[*]}"
    SSH_CMD "nvwa update $BASELINE_KERNEL_VERSION" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" &
    REMOTE_REBOOT_WAIT 2 15
    CHECK_RESULT $?
    #确认线程热迁移成功
    nvwa_procee_confirm "${pids[*]}"
    CHECK_RESULT $?
    last_reboot_sec=$(SSH_CMD "last reboot | head -1 | awk '{print \$8}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -1 | sed 's/\r//')
    [ "$last_reboot" != "$last_reboot_sec" ]
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    #恢复环境
    clean_redis
    restore_nvwa_restore
    clean_nvwa
    LOG_INFO "End to restore the test environment."
}
main "$@"
