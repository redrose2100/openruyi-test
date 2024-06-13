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
#@Date          :   2024-06-06
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
    systemctl start oeaware
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "start oeaware failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    LOG_INFO "操作步骤1、查询指定插件状态oeawarectl --query xx.so"
    oeawarectl --query libthread_collector.so | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "query plugin failed"
    oeawarectl --query libthread_scenario.so | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "query plugin failed"
    oeawarectl --query libpmu.so | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "query plugin failed"
    LOG_INFO "预期结果１、查询成功"

    LOG_INFO "操作步骤2、查询所有插件实例依赖oeawarectl -Q"
    oeawarectl -Q | grep "Generate dependencies graph dep.png"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -Q"
    LOG_INFO "预期结果２、查询成功"

    LOG_INFO "操作步骤3、查询指定插件实例依赖oeawarectl --query-dep 插件实例"
    oeawarectl --query-dep thread_scenario | grep "Generate dependencies graph dep.png"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --query-dep"
    LOG_INFO "预期结果3、查询成功"

    LOG_INFO "操作步骤4、删除插件oeawarectl -r|--remove 插件"
    oeawarectl -r libthread_scenario.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -r|--remove"
    oeawarectl -q | grep "libthread_scenario.so"
    CHECK_RESULT $? 0 1 "query plugin failed"
    LOG_INFO "预期结果4、删除成功"

    LOG_INFO "操作步骤5、加载对应类型插件oeawarectl -l|--load xx.so -t|--type t"
    oeawarectl -l libthread_scenario.so -t scenario | grep "Plugin loaded successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -l|--load"
    oeawarectl -q | grep "libthread_scenario.so"
    CHECK_RESULT $? 0 0 "query plugin failed"
    LOG_INFO "预期结果5、加载成功"
    
    LOG_INFO "End to run test."
    }

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
