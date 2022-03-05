#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test restorecond.service restart
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    #允许vsftp匿名用户写入权限
    setsebool -P allow_ftpd_anon_write=1
    CHECK_RESULT $?
    #allow system cron jobs to relabel filesystem for restoring file contexts, you must turn on the cron_can_relabel boolean. Disabled by default
    setsebool -P cron_can_relabel 1
    CHECK_RESULT $?
    #allow all daemons the ability to read/write terminals, you must turn on the daemons_use_tty boolean. Disabled by default
    setsebool -P daemons_use_tty 1
    CHECK_RESULT $?
    #allow all domains to execute in fips_mode, you must turn on the fips_mode boolean. Enabled by default
    setsebool -P fips_mode 1
    CHECK_RESULT $?
    #allow all domains to use other domains file descriptors, you must turn on the domain_fd_use boolean. Enabled by default.
    setsebool -P domain_fd_use 1
    CHECK_RESULT $?
    #allow all domains to have the kernel load modules, you must turn on the domain_kernel_load_modules boolean. Disabled by default
    setsebool -P domain_kernel_load_modules 1
    CHECK_RESULT $?
    #enable reading of urandom for all domains, you must turn on the global_ssp boolean. Disabled by default.
    setsebool -P global_ssp 1
    CHECK_RESULT $?
    #enable polyinstantiated directory support, you must turn on the polyinstantiation_enabled boolean. Disabled by default.
    setsebool -P polyinstantiation_enabled 1
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    setsebool -P allow_ftpd_anon_write=0
    wait
    setsebool -P cron_can_relabel 0
    wait
    setsebool -P daemons_use_tty 0
    wait
    setsebool -P domain_kernel_load_modules 0
    wait
    setsebool -P fips_mode 0
    wait
    setsebool -P polyinstantiation_enabled 0
    LOG_INFO "End to restore the test environment."
}

main "$@"
