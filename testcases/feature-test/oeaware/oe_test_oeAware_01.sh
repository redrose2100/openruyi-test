#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-04
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    LOG_INFO "安装oeAware-manager"
    DNF_INSTALL "oeAware-manager"

    LOG_INFO "启动服务"
    systemctl daemon-reload
    CHECK_RESULT $? 0 0 
    systemctl start oeaware
    CHECK_RESULT $? 0 0 
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "操作步骤１、查看帮助信息oeawarectl --help"
    oeawarectl --help | grep "usage: oeawarectl [options]"
    LOG_INFO "预期结果１、显示所有参数信息"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --help"

    LOG_INFO "操作步骤２、查询所有插件状态oeawarectl -q"
    oeawarectl -q | grep "Show plugins and instances status"
    LOG_INFO "预期结果２、显示所有插件及实例状态"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -q"

    LOG_INFO "操作步骤３、查询支持的插件列表oeawarectl --list"
    oeawarectl --list | grep "Plugin list as follows"
    LOG_INFO "预期结果3、显示支持的以及安装的插件"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --list"

    LOG_INFO "操作步骤４、安装指定插件oeawarectl -i|--install name"
    DNF_INSTALL "numactl"
    oeawarectl -i numafast | grep "numafast"
    CHECK_RESULT $? 0 0
    rpm -e numafast
    LOG_INFO "预期结果4、安装成功"

    LOG_INFO "操作步骤５、使能插件实例oeawarectl -e|--enable 插件实例"
    oeawarectl -e thread_scenario | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -e collector_pmu_sampling | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0
    oeawarectl -e collector_pmu_counting | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -e collector_pmu_uncore | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -e collector_spe | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -e thread_collector | grep "Instance enabled failed, because instance is already enabled"
    CHECK_RESULT $? 0 0 
    LOG_INFO "预期结果5、使能成功"
    oeawarectl -q | grep "thread_scenario(available, running)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_sampling(available, running)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_counting(available, running)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_uncore(available, running)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_spe(available, running)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "thread_collector(available, running)"
    CHECK_RESULT $? 0 0
    
    LOG_INFO "操作步骤６、禁用插件实例"
    oeawarectl -d thread_scenario | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d collector_pmu_sampling | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d collector_pmu_counting | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d collector_pmu_uncore | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d collector_spe | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d thread_collector | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 
    oeawarectl -d thread_collector | grep "Instance disabled failed, because instance is already disabled"
    CHECK_RESULT $? 0 0 
    LOG_INFO "预期结果6、禁用成功"
    oeawarectl -q | grep "thread_scenario(available, close)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_sampling(available, close)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_counting(available, close)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_pmu_uncore(available, close)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "collector_spe(available, close)"
    CHECK_RESULT $? 0 0
    oeawarectl -q | grep "thread_collector(available, close)"
    CHECK_RESULT $? 0 0

    LOG_INFO "End to run test."
    }

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
