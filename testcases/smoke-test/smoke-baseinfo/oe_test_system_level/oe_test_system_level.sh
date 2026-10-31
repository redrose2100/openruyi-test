#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/04/19
# @License   :   Mulan PSL v2
# @Desc      :   Test system level
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 所有 systemd 操作都下发到 NODE2：set-default 与 isolate 会直接切换运行 target，
# 在 NODE1 上执行会打断本机上正在运行的其他任务，甚至让 NODE1 无法继续被调度。
REMOTE_TARGET_FILE="/tmp/system_level_orig_target"

function remote_systemctl() {
    SSH_CMD "$1" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    default_target="poweroff.target rescue.target multi-user.target graphical.target reboot.target"
    # 原值存到 NODE2 本地文件，恢复时用 \$(cat ...) 让远端自行求值，
    # 避免在 NODE1 侧解析 SSH 输出（输出里可能混有 spawn/提示等噪声）。
    remote_systemctl "systemctl get-default > ${REMOTE_TARGET_FILE}"
    CHECK_RESULT $? 0 0 "Failed to get default target on NODE2"
    # 备份文件一落地就算准备完成，后续即使 early exit 也要走恢复流程
    PREPARE_DONE=1
    # 从 SSH 输出里只提取形如 xxx.target 的片段，忽略 spawn/登录提示等噪声
    target=$(remote_systemctl "cat ${REMOTE_TARGET_FILE}" | tr -d '\r' | grep -oE '[A-Za-z0-9_-]+\.target' | tail -n 1)
    # 取值失败时退回 multi-user.target，避免 run_test 里的 set-default 收到空参数而误判
    if [ -z "${target}" ]; then
        LOG_WARN "Failed to parse original default target on NODE2, fallback to multi-user.target."
        target="multi-user.target"
    fi
    LOG_INFO "original default target on NODE2 is ${target}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    case $target in
    poweroff.target)
        LOG_INFO "default target is poweroff "
        ;;
    rescue.target)
        LOG_INFO "default target is rescue"
        ;;
    multi-user.target)
        LOG_INFO "default target is multi-user"
        ;;
    graphical.target)
        LOG_INFO "default target is graphical"
        ;;
    reboot.target)
        LOG_INFO "default target is reboot"
        ;;
    esac
    for i in $default_target; do
        remote_systemctl "systemctl set-default $i" && LOG_INFO "set-default $i success"
    done
    remote_systemctl "systemctl set-default ${target}"
    CHECK_RESULT $? 0 0 "set-default execution failed"
    remote_systemctl "systemctl list-units --type target | egrep 'multi-user.target|graphical.target'"
    CHECK_RESULT $? 0 0 "list-units execution failed"
    remote_systemctl "systemctl isolate graphical.target"
    CHECK_RESULT $? 0 0 "isolate execution failed"
    remote_systemctl "systemctl list-units --type target | grep graphical"
    CHECK_RESULT $? 0 0 "list-units execution failed"
    remote_systemctl "systemctl isolate multi-user.target"
    CHECK_RESULT $? 0 0 "isolate execution failed"
    remote_systemctl "systemctl list-units --type target | grep graphical"
    CHECK_RESULT $? 1 0 "list-units execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "${PREPARE_DONE:-0}" != "1" ]; then
        LOG_WARN "Test environment was not prepared, skip restore."
        return 0
    fi
    # 用例执行完 NODE2 停在 multi-user.target，这里先回写 default。
    # 恢复失败只告警，不用 CHECK_RESULT 反转用例结论。
    remote_systemctl "if [ -s ${REMOTE_TARGET_FILE} ]; then systemctl set-default \$(cat ${REMOTE_TARGET_FILE}); fi" ||
        LOG_WARN "Failed to restore default target on NODE2"
    # 运行态也切回原 target，但原值是电源类 target（poweroff/reboot）时只回写 default，
    # 绝不 isolate，否则会把 NODE2 直接关机或重启。
    remote_systemctl "t=\$(cat ${REMOTE_TARGET_FILE} 2>/dev/null); case \$t in graphical.target|multi-user.target|rescue.target) systemctl isolate \$t ;; *) echo 'skip isolate for power target' ;; esac" ||
        LOG_WARN "Failed to isolate original target on NODE2"
    remote_systemctl "rm -f ${REMOTE_TARGET_FILE}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
