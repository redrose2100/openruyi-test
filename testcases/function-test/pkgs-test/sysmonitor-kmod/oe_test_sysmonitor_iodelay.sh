#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojintao
# @Contact   :   mjt1220@126.com
# @Date      :   2023/07/26
# @License   :   Mulan PSL v2
# @Desc      :   sysmonitor 本地磁盘io延时监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

negative_numbers="-1234"
words="abc"
special_characters="~\!@#%^*"
big_num="999999999999"
# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp -a "${sysmonitor_conf:-}" "${sysmonitor_conf}".bak
    sed -i "/^IO_DELAY_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    sed -i "/^IO_DELAY_ALARM=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    monitor_restart
    cp -a "${IODELAY_CONF}" "${IODELAY_CONF}".bak
    sed -i 's|#||g' "${IODELAY_CONF}"
}

# 测试点的执行
function run_test() {
    # step 1: 查看/etc/sysmonitor/iodelay配置文件，观察DALAY_VALUE默认配置
    delay_value=$(grep DELAY_VALUE "${IODELAY_CONF}" | awk -F\" '{print $2}')
    [ "$delay_value" -eq 500 ] || oe_err "default check failed"
    # step 2: 配置DALAY_VALU的值为空\注释掉该配置，reload sysmonitor
    # sysmonitor reload成功，sysmonitor日志中没有io delay monitor: configuration illegal日志
    # 等待5分钟后可以看到iodelay 的阈值为默认值500（I/O delay threshold is 500）
    sed -i "/^DELAY_VALUE=/ s/=.*/=\"\"/" "${IODELAY_CONF}"
    monitor_restart
    fn_wait_for_monitor_log_print "io delay monitor: configuration illegal" 5 && oe_err "iddelay  illegal check failed"

    sed -i "/^DELAY_VALUE.*/s/^/#&/" "${IODELAY_CONF}" | xargs grep "^#IO_DELAY_MONITOR" "${IODELAY_CONF}"
    systemctl reload sysmonitor
    fn_wait_for_monitor_log_print "io delay monitor: configuration illegal" 5 && oe_err "iddelay  illegal check failed"

    sed -i 's|#||g' "${IODELAY_CONF}"
    # step 3: 配置DALAY_VALU的值为大于等于0的正整数，位数大于9位（0\9999999999），reload sysmonitor
    sed -i "/^DELAY_VALUE=/ s/=.*/=\"$big_num\"/" "${IODELAY_CONF}"
    # sysmonitor reload成功，sysmonitor日志中没有io delay monitor: configuration illegal日志
    # 等待5分钟后可以看到iodelay 的阈值为0\999999999，只取前9位
    systemctl reload sysmonitor
    fn_wait_for_monitor_log_print "io delay monitor: configuration illegal" 5 && oe_err "illegal check failed"
    cat "${IODELAY_CONF}"

    sleep 300 # 代码中写死5分钟一轮监控
    cat "${IODELAY_CONF}"
    fn_wait_for_monitor_log_print "IO delay is normal. I/O delay threshold is 999999999" || oe_err "$i threshold check failed"

    # step 4: 配置DALAY_VALU的值为非法值（负数、字母、非法字符）
    local array=("$negative_numbers" "$words" "$special_characters")
    for ((i = 0; i < ${#array[@]}; i++)); do
        true > "${sysmonitor_log:-}"
        sed -i "/^DELAY_VALUE=/ s/=.*/=\"${array[i]}\"/" "${IODELAY_CONF}"
        systemctl reload sysmonitor
        fn_wait_for_monitor_log_print "io delay monitor: configuration illegal" || oe_err "$i illegal check failed"
    done
}

# 后置处理，恢复测试环境
function post_test() {
    mv "${sysmonitor_conf}".bak "${sysmonitor_conf}"
    mv "${IODELAY_CONF}".bak "${IODELAY_CONF}"
    monitor_restart
}

main "$@"
